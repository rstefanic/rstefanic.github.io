---
title: 'Groups, Monoids, and Semigroups'
author: 'Robert'
---

I want to explore the relationship between Groups, Monoids, and Semigroups. 
These abstract algebras are powerful, and in programming, once a data structure
has built around one of these algebras, it can change how we understand the data
that we're manipulating and help us reason about the data that we're working
with. 

My goal here is to give a formal definition for each of these algebras, and then
give real world code exampels for each of them. Perhaps in the future, I'll write another post where I explore other
algebraic structures such as magmas/groupoids, abelians, or semilattices.

___
## Definitions

### Semigroups

Before we build up to notion of groups, let's start with semigroups. After all,
a semigroup is a partial group. A semigroup is a set (i.e. collection) that has an 
associative binary operation.

Let's quickly refresh what a binary operation is and
what it means for something to be associative. 

A binary operation is a function that takes two elements of them same set, and
outputs another element from that set.[<sup>1</sup>](#note-1) Examples of this are fairly obvious such as
addition (+), subtraction (-), string concatenation, etc. 

Haskell:
```haskell
(+) :: Int -> Int -> Int
(-) :: Int -> Int -> Int
(++) :: String -> String -> String
```

C++:
```cpp
int add(int a, int b) {...}
int subtract(int a, int b) {...}
std::string concat(std::string a, std::string b) {...}
```

The associativity property says that given a sequence of two or more binary
operations, the order in which these operations are performed do not matter. An
example of this would be addition, where $1 + (2 + 3) = (1 + 2) + 3$. From the
previous examples given, addition and string concatenation are associative
binary operations, but subtraction is not associative because the order of
operations matter in subtraction ($1 - (2 - 3) \neq (1 - 2) - 3$).[<sup>2</sup>](#note-2) 

So given set $S$, $S$ is a semigroup if it has the binary operation of $f$,
where $f$ is associative.

\[f\colon S\times S\rightarrow S\]

\[\forall(\alpha, \beta, \delta)\in S\colon f(f(\alpha, \beta), \delta) = f(\alpha,
f(\beta, \delta))\]
___
### Monoids

Every monoid is a semigroup. In fact, if you look at the typeclass for Monoid in
Haskell, you'll see that Monoid requires Semigroup:

```Haskell
class Semigroup a => Monoid a where
  mempty :: a
  mappend :: a -> a -> a
  mconcat :: [a] -> a
```

So what exactly is the difference here? You'll also notice that ```mappend``` in 
the definition for Monoid is the same as our definition of $f$ from above. 

Monoids are just semigroups that have an identity element. For element $x$
(where $x$ is any element from set $S$), when $x$ and the identity element are 
combined with $f$, the result will always be $x$.

In the example of addition, the identity element would be 0 because $0 + x = x$.
In the case of multiplication, the identity element would be 1 because $1\cdot x
= x$. And in the case of string concatenation, the identity element would be an
emtpy string because ```"" + "Hello!" = "Hello!"```.

So given set $S$, $S$ is a monoid if it has the binary operation of $f$, where
$f$ is associative and $S$ has an identity element.

\[f\colon S\times S\rightarrow S\]

\[\forall(\alpha, \beta, \delta)\in S\colon f(f(\alpha, \beta), \delta) = f(\alpha,
f(\beta, \delta))\]

\[\forall x \exists!e \in S\colon f(e, x) = x\]
___
### Groups

Just as monoids have all of the properties of a semigroup with an additional
property, groups has all of the properties of a monoid with the additional property 
of an inverse operation.

An inverse operation says that given any element in the closed set, there is an
inverse element that also exists. So to continue with our math examples, for
every number in the set of all integers, for any number that you give me (e.g. 5), 
that number will always have a corresponding negative number (-5). So if set $S$ 
is all the integers, and we have the addition operator, then $S$ is a group.

In contrast to our other example of string concatenation, strings do not have a
cooresponding inverse or reciprocal string; thus it cannot be a group. (What
would the inverse of ```"Hello!"``` be?)

So to summarize, $S$ is a group if it has the binary operation of $f$, where $f$
is associative, $S$ has an identity element, and for any element $x$ in $S$,
there exists element $y$ in $S$, where $f$ applied to $x$ and $y$ will yield the
identity element.

\[f\colon S\times S\rightarrow S\]

\[\forall(\alpha, \beta, \delta)\in S\colon f(f(\alpha, \beta), \delta) = f(\alpha,
f(\beta, \delta))\]

\[\forall x \exists!e \in S\colon f(e, x) = x\]

\[\forall x \exists y \in S\colon y = x^{-1}\]

\[\forall x \exists y \exists!e \in S\colon f(x, y) = e\]
___
## Groups, Monoids, and Semigroups in the Wild

Alright, so now we know what these algebras are, but how do they apply to real
world situations? I've come up with three examples to show how they may be used.

### Semigroup Example

Let's say that we have a database with a really large view that we want to
query, but we almost never need all of the fields from the view. This looks like
it would be a great job for a semigroup!

In Haskell, we could create a type that would hold our query:

```haskell
newtype SqlField = SqlField String
    deriving (Eq, Show)

data SqlQuery = SqlQuery
    { selectFields :: NonEmpty SqlField
    , fromTable    :: String
    , whereClause  :: String
    } deriving (Eq, Show)
```

Since we could never select nothing from a table, ```selectFields``` must always have a
value. So this looks like a great fit for a semigroup. We could define an
instance for semigroup for ```SqlQuery``` that could combine two selectFields:

```haskell
instance Semigroup SqlQuery where
    (SqlQuery fields t w) <> (SqlQuery fields' t' w') =
        SqlQuery (fields <> fields') t w
```

Now I have an easy way to combine two select clauses by just combining them by
using ```query1 <> query2```. And, like all semigroups, it's associative, so I 
could just keep adding additinal fields to the query ```((query1 <> query2) <> query3) == (query1 <> (query2 <> query3))```. 

In a real situation, you'd want to expand ```(<>)``` by including a check to make 
sure that the fields in ```fields``` are different from the fields in ```fields'``` and to make sure 
that the the SqlQueries are pulling from the same table, but this was meant 
as a quick example of a semigroup.

### Monoid Example

A common example for a monoid is a analong clock. It has an associtaive binary
operation (the adding of hours) and an identity (the 12th hour). The monoid 
definition for a clock may look something like this:

```haskell
newtype Clock = Clock Int 
    deriving (Eq, Show)

instance Monoid Clock where
    (Clock hour) <> (Clock hour') = Clock $ (hour + hour') `mod` 12
    mempty = Clock 12
```

No matter how many hours you're adding, you'll never fall outside of the 12
hours of an analog clock.

### Group Example

Groups, admittingly, are a bit more difficult to find in programming. They are a
very useful concept in mathematics, but within programming, the pattern doesn't
appear very often.

One example though could be a colors that you're keeping for a picture. It has
an empty color (white), an associative binary operation that allows you to
combine colors, and an operation that would give you that color's negative.

```haskell
data Pixel = Pixel
    { red   :: Int
    , green :: Int
    , blue  :: Int
    } deriving (Eq, Show)

addColors :: Int -> Int
addColors x y = if val > 255 then 255 else val
    where val = x + y

negateColor :: Int -> Int
negateColor x = 255 - x
                  
instance Group Pixel where
    mempty = Pixel 0 0 0
    (Pixel r g b) <> (Pixel r' g' b') =
        Pixel (addColors r r') (addColors g g') (addColors b b')
    inverse (Pixel r g b) = 
        Pixel (negateColor r) (negateColor g) (negateColor b)
```

___
<span id="note1">1</span>: This is another good reason to used a type language
because you can then add this information to your functions, where in duck typed
langauges, your functions cannot enforce these contraints.

<span id="note2">2</span>: A set that has a single binary operation is known as
a groupoid. So while subtraction is not a semigroup, it is a groupoid because it
contains a closed binary operation, as this is the only requirement that needs
to be met in order for something to be a groupoid. A closed binary operation
just means that the binary operation always yeilds another member of the same
set.
