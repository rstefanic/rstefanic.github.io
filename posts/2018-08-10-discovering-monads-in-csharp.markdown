---
title: Discovering Monads in C#
author: Robert Stefanic
---

### The Motivation

This was originally a post that I\'d written on reddit, but I figured it\'d be worth it to clean it up and clarify what I was saying.

The post was in regards to someone trying to use a monad in C# just to practice monads. I replied by saying that the best way to learn how monads work was to discover them. 

It\'s much better to see how they can help you rather than just being told \"this pattern will help you write code.\" At the end of the day, monads are just a design pattern that help you write and maintain your code.

Before I start this though, I just wanted to clarify two quick points. The first one is that some people point to ```Nullable<T>``` as an instance of a monad in C#. 

While ```Nullable<T>``` can be seen as something similar to a maybe monad in the sense that it allows a type to be null, it\'s lacking some features that a ```Maybe<T>``` monad would have. But that doesn\'t mean ```Nullable<T>``` isn\'t what you\'re looking for: it might be exactly what you need. I find myself reaching for ```Nullable<T>``` more and more because there\'s no reason for me to use a ```Maybe<T>``` monad.

With that said though, I do find myself using the maybe monad in my C# projects here and there, and I figured I\'d share a use case for it by using a real world example.

My second point is that this is not a full monad. I\'m sure someone would have pointed it out, and I just want to make it clear. In category theory, a monad needs to have two natural transformations (η and μ), but this implementation below only has one (η). The other transformation is irrelevant to this example, and since I\'m writing code for a real world application, I had no need to write the other part because it would\'ve never been used.

So, now onto what my problem was and an example of how implementing a maybe monad helped.

___
### My Real World Problem

I have an application that makes a request to an API for currency conversion rates. I send off a request to an API, I get the conversion rate (which is a decimal type), and then I pass that conversion rate value around to a few functions. However, the application I\'m working on allows the user to type in any three letter country code for a conversion rate. So Joe Blow could say that they want to convert USD to YZZ. Well, YZZ isn\'t a currency code that\'s recognized by the API that I\'m using, so I wouldn\'t get anything useful back; yet, once I get a value back, I\'m passing it around to a few functions.

And besides just this user error, there are other things that could go wrong! There could be an error while connecting to the API or there could be an internal server error with the API that I\'m requesting, all on top of the fact that the user could input a garbage value. So what do I do if I get an error instead of the decimal that I was initially requesting?

This is where the maybe monad comes in. I\'m expecting a decimal value to be returned when I make a request to this API, but we\'ve just identified some cases where I\'m not going to get a decimal value back. There are cases here where I could get an error back. So I want to construct a type that accommodates both a decimal value and the possibility for error. A maybe monad could help me handle this, along with giving me some extra functionality.

___
### A Quick Detour into Types

Let\'s briefly talk about types. A type is a collection of values. So what makes up the decimal type that I\'m expecting in this example? It\'s a number anywhere between 79228162514264337593543950335 and -79228162514264337593543950335. That\'s quiet a range of possible values. 

In the example that I just gave though, I want to **extend** the range of possible values on the decimal type could have and say that \"this decimal could be any number between -79228162514264337593543950335 and 79228162514264337593543950335, **or** it could be null.\" A maybe monad would allow me to do just this. I could extend the decimal type in this way, and say \"this is a type that is either a number with a precision of 28-29 significant digits or there is no value.\"

By adding a maybe monad, instead of just saying that \"I\'m expecting a decimal value back from this request\", I\'m saying that \"I\'m expecting either a decimal value back or nothing back from this request.\" Now I\'m doing some error handling through my types. And this is powerful, because now I can write one function that does my null checking for me, without having to manually write my error checking code for each function that receives the decimal value that I retrieved from the API.

___
### Let\'s start building the monad!

So now that we know how it can help us, let\'s build a (partial) monad! I started with an abstract class called ```Maybe<T>```, and I created two other classes that inherit from it: ```Just<T>``` and ```Nothing<T>```. So if something is a ```Maybe<T>```, that means it is either a ```Just<T>``` or a ```Nothing<T>```.

```cs
public abstract class Maybe<T>
{
     public static Func<Maybe<T>, Func<T, Maybe<T>>, Maybe<T>> Bind = (a, func) =>
     {
          // Cast the Maybe<T> Value that was passed in as a Just<T>
          // If it cannot be cast to Just<T>, then validJust will be null.

          Just<T> validJust = a as Just<T>;

          // If the cast is null, return Nothing<T>, otherwise pass the value
          // contained within Just<T> to the function that was passed to Bind.

          if (validJust == null)
              return new Nothing<T>();
          else
              return func(validJust.Value);
      };

      public abstract override string ToString();
  }

public class Nothing<T> : Maybe<T>
{
    // This doesn't have any members because Nothing<T> 
    // a failure in computing something.

    public override string ToString()
    {
        return "Nothing";
    }
}

public class Just<T> : Maybe<T>
{
    // This has one member, anything of type T.

    public T Value { get; private set; }

    public Just(T value)
    {
        this.Value = value;
    }

    public override string ToString()
    {
        return "Just ("+ this.Value.ToString() + ")";
    }
}
```

```Nothing<T>``` is my \"null\" type and ```Just<T>``` represents a value of type ```T```. ```Nothing<T>``` doesn\'t hold any value while ```Just<T>``` does hold a value.

The base class of ```Maybe<T>``` has a function called ```Bind```. Since ```Just<T>``` and ```Nothing<T>``` are inherited from ```Maybe<T>```, either ```Just<T>``` or ```Nothing<T>``` will work with my ```Bind``` function. 

The ```Bind``` function is what\'s saving me headaches here, and it\'s why I would choose to use a maybe monad instead of ```Nullable<T>```. ```Bind``` is a function that takes a ```Maybe<T>``` (so any inherited class of ```Maybe<T>```), another function that takes a value of ```T``` and outputs a ```Maybe<T>```, and returns a ```Maybe<T>```.

Remember earlier when I said I can write one function that does my null checking for me? This is what ```Bind``` is doing for me. It\'s doing the error checking for me. I pass a ```Maybe<T>``` and a function to ```Bind```. If the first argument to bind is ```Nothing<T>```, then ```Bind``` just returns ```Nothing<T>```. If it\'s ```Just<T>```, then it will return the value from applying the function to the value inside of ```Just<T>```. Check out my comments in ```Bind``` for more information.

___
### Applying our monad to a real world scenario

So now let\'s look at the snippet of code where I\'m parsing the response from the API:

```cs
private static Maybe<decimal> parseExchangeRate(string rate)
{
    if (decimal.TryParse(rate, out decimal exchangeRate))
        return new Just<decimal>(exchangeRate);
    else
        return new Nothing<decimal>();
}
```

So this function takes the rate, and parses it. If it was successful, then it returns a ```Just<decimal>``` containing the rate. If it failed, then I return ```Nothing<decimal>```.

Now that the parsed rate is of ```Maybe<decimal>```, I don\'t have to check to see if it\'s null or not because ```Bind``` does it for me. 

Now this is where things get interesting! Once I have my parsedExchangeRate, I can just pass it right along to ```calculateRate```. This means that I can just multiple the result from ```parseExchangeRate``` without having to check to see if there is a value there or not: I just pass the value from ```parseExchangeRate``` along with my mutliplication function to ```Bind```, and ```Bind``` will handle the null checking for me!

```cs
private Maybe<decimal> calculateRate(Maybe<decimal> parsedExchangeRate)
{
    return Maybe<decimal>.Bind(parsedExchangeRate, x =>
    {
        return new Just<decimal>(x * this.SourceAmount);
    });
}
```

*As a quick side note about the code above, SourceAmount is a member variable of the class that contains this method.*

If the value that was passed to ```calculateRate``` was ```Just<decimal>```, then the result will be ```Just<decimal>```. On the other hand, if ```Nothing<decimal>``` was passed as the value, then the output will be ```Nothing<decimal>```. 

___
### Summary

From this example, you can see that you don\'t need monads to program. They aren\'t necessary. You could have written this without writing a monad accommodate failure.

But look at what we\'ve got for free through this extra work. I don\'t want to write the error checking code over and over again because it\'s tedious. I wrote the error checking code once in ```Bind```, and it takes care of the checking for me. I can now compose functions using ```Maybe<decimal>``` over and over, and not worry about whether or not I\'m error checking correctly because I\'ve written once. On top of that, since ```Maybe<T>``` is a generic, I can extend other types just like I extended the decimal type.

The whole point is that I saved myself some time and headaches. I wrote my error checking code once, I\'m confident in the sense that I know it works properly, and now I don\'t have to write it again. It can be re-used with other types, and I can easily compose other functions with these new extended type I\'ve created.