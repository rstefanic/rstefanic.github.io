---
title: 'The Definition of a Programming Language'
---

<a href="https://i.redd.it/m41loixjno811.jpg" target="_blank">There</a> <a href="https://i.redd.it/5jlyb9bz0ty01.png" target="_blank">are</a> <a href="https://i.redd.it/6s8yeenm3a401.jpg" target="_blank">a</a> <a href="https://i.redd.it/s4kd391zv7611.png" target="_blank">lot</a> <a href="https://i.redd.it/zp2qvdhpamyz.jpg" target="_blank">of</a> <a href="https://i.redd.it/in6vgbed03511.jpg" target="_blank">bad</a> <a href="https://i.redd.it/00dxkvgb4td11.jpg" target="_blank">jokes</a> <a href="https://i.redd.it/ws53g9its8f11.png" target="_blank">about</a> <a href="https://i.redd.it/u7o72jnjzx411.jpg" target="_blank">HTML</a> <a href="https://i.redd.it/kb68vokgv0411.jpg" target="_blank">not</a> <a href="https://i.imgur.com/rRc2P2a.jpg" target="_blank">being</a> <a href="https://i.redd.it/c8u49zjv5p611.jpg" target="_blank">a</a> <a href="https://i.redd.it/32vqf2dfl5a11.jpg" target="_blank">programming</a> <a href="https://i.redd.it/trrlbydduqo01.png" target="_blank">langauge</a>. Despite them being bad, the other problem that I have with them is that I think the joke starts from the mistaken premise that HTML is not a programming language. 

I\'ve had numerous conversations with people both online and in person over the definition of a programming language. I originally held a view that would say that would agree that HTML is not a programming language, but after reconsidering my position through these conversations, I eventually came to think that my definition of a programming language was too restrictive and hard to defend, and now I do think that HTML is a programming language. 

My goal by the end is to convince you that HTML is, in fact, a programming language. At the very least, if I don\'t succeed in convincing you that HTML is a programming language, then I at least hope to show you that the usual definitions that are given as to what a programming language is are problematic.

___
### What is a programming language?

I\'m going to start with a basic definition and then move through some competing definitions that are given as a supposedly better alternative to my initial definition. In the end, I believe this first definition that I\'m about to give is the correct definition, and while this definition may seem too permissive and wide at first, I will show how these modified definitions lead to other problems. Of course, one could accept one of these different definitions of a programming language other than the one that I\'m about to defend, but part of my point is that accepting one of these other definitions will leave one with an idiosyncratic view of what a programming language is, and we\'re better off just accepting this starting definition as it doesn’t needlessly complicate things.

Let’s start with a basic definition of a programming language:

>**PL**: A programming language is a set of instructions, created using a special syntax, that is used to produce a specific output.

This seems like a good starting point, but most people\'s problem with it is that it clearly encapsulates markup languages like HTML. HTML a set of instructions that are used to produce a specific output when fed to certain programs. Take for example the &lt;h1&gt; tag. It can be conceived of as a function that takes an argument in between it\'s open and closing tags, which tells a browser to render the tag with the argument passed to it. It\'s a declarative programming language in the sense that you’re telling the browser how to output something. 

___
### First Objection to PL
This first objection is clearly ridiculous, yet I\'ve encountered it more than once, and at the very least, I think it is worth considering. The objection to PL that I\'ve heard is that languages like HTML cannot be a programming language because it is not compiled. So in order to exclude HTML, we have to modify our definition to say that it must be compiled.

>**PL-1**: A programming language is a set of instructions, created using a special syntax, that must be compiled in order to produce a specific output.

The problem here is that this definition seems so restrictive that we\'d end up excluding interpreted languages like Python, Javascript, and Ruby. These are clearly languages that are used to solve real problems and run businesses. So I don’t think PL-1 is a very useful way to think about programming languages. This would lead us to say that \"someone who writes C is using a programing language, but someone who writes Python is not using a programing language\", and on the face of, this seems wrong.

___
### Second Objection to PL 
The second definition seems more reasonable at first, but I still find it confused for similar reasons given in my criticism of PL-1. PL says that HTML is a programming language because it\'s a set of instructions that are used to produce a specific output when fed to *certain programs*. Hence, the objection that I hear is that HTML cannot be a programming language because it only works in conjunction with certain programs like a browser.

>**PL-2**: A programming language is a set of instructions, created using a special syntax, that can be ran individually separate from another program.

But PL-2 runs into a similar problem that PL-1 runs into, which is that it excludes interpreted languages (because they require an interpreter). Moreover, this definition is actually *more* restrictive than PL-1 in that it excludes languages like Java because Java is compiled to bytecode that only be ran on the JVM (which is needed to execute Java programs).

___
### Third Objection to PL
The third objection that I\'ve heard argues that HTML is not a programming language because it\'s not Turing complete. 

>**PL-3**: A programming language is a set of instructions, created using special syntax that can mimic a Turing complete machine, in order to produce a specific output.

This is odd too though because while this would exclude HTML, it would still include languages like TeX. TeX is Turing complete and also another markup language used to produce a specific output. On top of that, this would exclude other languages like SQL because SQL is not Turing complete, while fringe languages such as Whitespace would still be included. So this route seems to be a dead end to me as well.

___
### Fourth Objection to PL

This final objection to PL seems to me to be the most reasonable, but I still think it ultimately fails. The languages that I mentioned in my objections to PL-3 were nearly all examples of Domain Specific Languages (DSL). So then a programming language must not be a DSL.

>**PL-4**: A programming language is a set of instructions, created using a special syntax that is not a DSL, in order to produce a specific output.

HTML, TeX, and SQL are examples of DSLs, and thus, they are excluded from our definition of a programming language. 
But the exclusion of DSLs rules out programming languages like Emacs Lisp because Emacs Lisp is a language specifically written for the domain of Emacs. It seems absurd to say that Emacs Lisp isn\'t a programming language, even though it *is* used to write programs. We could try to modify PL-4 so that it includes Emacs Lisp while excluding those other DSLs that I\'ve mentioned, but how would that definition look? We could try combining something like PL-3 and PL-4.

>**PL-4`**: A programming language is a set of instructions, created using a special syntax that is not a DSL, except in the case when the DSL is Turing complete, in order to produce a specific output. 

This definition seems incredibly ad-hoc. Without being given a reason as to why we should we consider DSLs that are Turing complete as the defining characteristic of what makes a programing language, I don\'t see why we should accept PL-4`.

On top of that, while PL-4` would include Emacs Lisp, it would also end up including TeX anyways, which is markup language. 

This route seems like it is going to get complicated quickly, and unless we have good reason to say that DSLs that are Turing complete is the relevant factor for considering what is a programing language and what is not a programing language, then it seems like we\'re better off abandoning this route. 

___
### Conclusion

After walking through the various objections to PL, we\'re still left with our boring and wide definition of PL. There could be other useful distinctions that I haven\'t heard or have failed to think of, and if you can think of a good distinction, then please let me know. There is clearly a major difference between a language like C and HTML. Yet looking through the definitions above, I don\'t think you can say that the difference is that one is a programming language while the other one is not. In the end, due to PL, we’re left saying that HTML is a domain specific restrictive declarative programming language that is not Turing complete.
