# Type on Latin keyboard, get Thai text

At first, refer to the given tables to get the characters you want. After a time this will become automatic.

Try live at https://www.eludev.fr/thai

# Programming language
The application is written with Elm, which allows for:
- easy and clean development
- very small application size (33 kb for the generated javascript)
- easy communication with javascript
- simple, consistent and efficient tooling

When faced with the problem of having to manage the placement of vowels before the consonant (see below) I was at first tempted to go back to rust for an imperative approach, but quickly it appeared that the functional approach provided by elm was far simpler and more effective. 

# Rationale

We tried to use a simple transcription close to phonetic value while retaining the logic of the Thai abugida:

## vowels:
We chose a transcription close to phonetic value as described for instance in "Gilles Delouche, Méthode de Thaï". See also [https://studythai.ai/blog/32-vowels](https://studythai.ai/blog/32-vowels)

The 9 basic vowels are transcribed as i, ü, u, e, ö, o, ä, a, ) (the closing paren representing an open o), with their long version i:, ü:, u:, e:, ö:, ä:, a:, ):

There are several diphtongs in thai, but 2 of them get a special transcript, namely ใ transcribed aï, and ไ transcribed aï', where ï is treated as a diacritic (see below).

## consonants:
Thai consonants fall into 3 groups: middle, high and low
- middle consonants have no diacritic mark: k, c, t, d ...
- high consonants have a ' or " diacritic
- low consonants have a - diacritic, possibly -' or -" if there are several variants of the same consonant

## vowels and consonants:
Just as in bengali for instance, vowels may appear to the right, over, under, to the left or to both sides of the consonant after which they are pronounced. It bengali, this is totally taken into account by the unicode specification, meaning I had to make no special effort for rendering any vowel.

So I was very negatively surprised to see that this was not the case for Thai: while putting vowels under or above their consonants was indeed taken care of, this is not the case for vowels to the left or to both sides of their consonant. For instance the vowel โ (pronounced o:) must be rendered to the left of consonant ก (pronounced k). But if you typed ko: in the initial version of the program, you would get กโ instead of โก which is the correct rendering (vowel โ to the left of consonant ก). This means that I had to programatically modify the result, so that if you type ko: you do get โก.

I understand there still are some issues with unicode rendering for thai script (see for instance [https://www.w3.org/International/sealreq/thai/](https://www.w3.org/International/sealreq/thai/)). One of them is probably linked with the fact that in thai, unlike hindi or bengali, vowels may be linked not with one consonant but with a cluster of 2 consonants, such as  kro: which must be rendered โกร (o: + k + r). I tried to take that into account in the present program. This looks to work, except that in longer strings the rendering is no longer correct, possibly due to stack overflow (hard to diagnose). So maybe we have a case for returning to good old imperative model (i.e. without recursion) ?

## tone marks
Thai script includes 4 tone marks, which are to be input as :
- ` for tone 1 (backtick)
- `' for tone 2 (backtick followed by ')
- `" for tone 3 (backtick followed by ")
- + for tone 4

## diacritics:
We use 6 diacritics, namely ' " ï M - and :

Diacritics are signs appended to vowels or consonants that change their value, as specified in the help tables.

To use ' or " as quotation marks, insert a space before them.

## characters with _ prefix:
We use _ as a prefix only in _) to get a regular ) since we use ) for open o 


## fonts

Usual fonts available on my mac did not ensure proper rendering of tone marks. But Google's `noto serif thai` works very well for that issue, so I use this font for any thai text in the program.


# Unrecognized characters

Any character not recognized is rendered unmodified.


# License

MIT
