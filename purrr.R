## ------------------------------------------------------------------------
is_even <- function(x) x %% 2 == 0
1:6 %>% keep(is_even)
1:6 %>% discard(is_even)


## ------------------------------------------------------------------------
1:6 %>% keep(negate(is_even))
1:6 %>% discard(negate(is_even))


## ------------------------------------------------------------------------
y <- list(NULL, 1:3, NULL)
y %>% compact()


## ------------------------------------------------------------------------
x <- y <- 1:3
names(y) <- c("one", "two", "three")


## ------------------------------------------------------------------------
names(x)
names(y)


## ------------------------------------------------------------------------
z <- list(x, y)
z %>% compact()
z %>% compact(names)


## ------------------------------------------------------------------------
is_even <- function(x) x %% 2 == 0
1:4 %>% map(is_even)


## ------------------------------------------------------------------------
is_even <- function(x) x %% 2 == 0
1:4 %>% map_lgl(is_even)


## ------------------------------------------------------------------------
1:4 %% 2 == 0


## ------------------------------------------------------------------------
n <- seq.int(100, 1000, 300)
rnorm(n) # length(n) is used for n!


## ------------------------------------------------------------------------
sem <- function(n) sd(rnorm(n = n)) / sqrt(n)
n %>% map_dbl(sem)


## ------------------------------------------------------------------------
1:3 %>% map_dbl(identity) %T>% print() %>% class()
1:3 %>% map_chr(identity) %T>% print() %>% class()
1:3 %>% map_int(identity) %T>% print() %>% class()


## ------------------------------------------------------------------------
x <- tibble(a = 1:2, b = 3:4)
list(a = x, b = x) %>% map_dfr(identity)
list(a = x, b = x) %>% map_dfc(identity)


## ------------------------------------------------------------------------
list(a = x, b = x) %>% map_df(identity)


## ------------------------------------------------------------------------
x <- list(1:3, 4:6)
x %>% map_dbl(1)
x %>% map_dbl(3)


## ------------------------------------------------------------------------
x <- list(
    c(a = 42, b = 13),
    c(a = 24, b = 31)
)
x %>% map_dbl("a")
x %>% map_dbl("b")


## ------------------------------------------------------------------------
a <- tibble(foo = 1:3, bar = 11:13)
b <- tibble(foo = 4:6, bar = 14:16)
ab <- list(a, b)
ab %>% map("foo")


## ------------------------------------------------------------------------
ab %>% map_depth(0, length)
ab %>% length()


## ------------------------------------------------------------------------
ab %>% map_depth(1, sum) %>% unlist()
ab %>% map_depth(2, sum) %>% unlist()
ab %>% map_depth(3, sum) %>% unlist()


## ------------------------------------------------------------------------
is_even <- function(x) x %% 2 == 0
add_one <- function(x) x + 1
1:6 %>% map_if(is_even, add_one) %>% as.numeric()


## ------------------------------------------------------------------------
1:6 %>% keep(is_even) %>% map_dbl(add_one)


## ------------------------------------------------------------------------
add_two <- function(x) x + 2
1:6 %>% 
    map_if(is_even, add_one, .else = add_two) %>%
    as.numeric()


## ------------------------------------------------------------------------
1:6 %>% map_at(2:5, add_one) %>% as.numeric()


## ------------------------------------------------------------------------
list(1:3, 4:6) %>% map(print) %>% invisible()
list(1:3, 4:6) %>% lmap(print) %>% invisible()


## ------------------------------------------------------------------------
f <- function(x) list("foo")
1:2 %>% lmap(f)
f <- function(x) list("foo", "bar")
1:2 %>% lmap(f)


## ------------------------------------------------------------------------
list(1:3, 4:6) %>% map(length) %>% unlist()


## ------------------------------------------------------------------------
wrapped_length <- . %>% length %>% list()
list(1:3, 4:6) %>% lmap(wrapped_length) %>% unlist()


## ------------------------------------------------------------------------
wrapped_length <- . %>% .[[1]] %>% length %>% list()
list(1:3, 4:6) %>% lmap(wrapped_length) %>% unlist()


## ------------------------------------------------------------------------
1:3 %>% map(print) %>% invisible()
1:3 %>% walk(print)


## ------------------------------------------------------------------------
x <- 1:3
y <- 3:1
map2_dbl(x, y, `+`)


## ------------------------------------------------------------------------
list(x, y) %>% pmap_dbl(`+`)


## ------------------------------------------------------------------------
z <- 4:6
f <- function(x, y, z) x + y - z
list(x, y, z) %>% pmap_dbl(f)


## ------------------------------------------------------------------------
x <- c("foo", "bar", "baz")
f <- function(x, i) paste0(i, ": ", x)
x %>% imap_chr(f)


## ------------------------------------------------------------------------
modify2(1:3, 3:1, `+`)

x <- c("foo", "bar", "baz")
f <- function(x, i) paste0(i, ": ", x)
x %>% imodify(f)


## ------------------------------------------------------------------------
pair <- function(first, second) {
    structure(list(first = first, second = second),
              class = "pair")
}
toString.pair <- function(x, ...) {
    first <- toString(x$first, ...)
    rest <- toString(x$second, ...)
    paste('[', first, ', ', rest, ']', sep = '')
}
print.pair <- function(x, ...) {
    x %>% toString() %>% cat() %>% invisible()
}


## ------------------------------------------------------------------------
1:4 %>% reduce(pair)


## ------------------------------------------------------------------------
1:4 %>% rev() %>% reduce(pair)


## ------------------------------------------------------------------------
1:4 %>% reduce(pair, .dir = "backward")


## ------------------------------------------------------------------------
1:3 %>% reduce(pair, .init = 0)
1:3 %>% rev() %>% reduce(pair, .init = 4)
1:3 %>% reduce(pair, .init = 4, .dir = "backward")


## ------------------------------------------------------------------------
# additional arguments
loud_pair <- function(acc, next_val, volume) {
    ret <- pair(acc, next_val)
    ret %>% toString() %>%
        paste(volume, '\n', sep = '') %>%
        cat()
    ret
}


## ------------------------------------------------------------------------
1:3 %>%
    reduce(loud_pair, volume = '!') %>%
    invisible()
1:3 %>%
    reduce(loud_pair, volume = '!!') %>%
    invisible()


## ------------------------------------------------------------------------
volumes <- c('!', '!!')
1:3 %>% reduce2(volumes, loud_pair) %>% invisible()
1:3 %>% 
    reduce2(c('!', '!!', '!!!'), .init = 0, loud_pair) %>% 
    invisible()


## ------------------------------------------------------------------------
res <- 1:3 %>% accumulate(pair)
print(res[[1]])
print(res[[2]])
print(res[[3]])

res <- 1:3 %>% accumulate(pair, .init = 0)
print(res[[1]])
print(res[[4]])

res <- 1:3 %>% accumulate(
    pair, .init = 0,
    .dir = "backward"
)
print(res[[1]])
print(res[[4]])


## ------------------------------------------------------------------------
greater_than_three <- function(x) 3 < x
less_than_three <- function(x) x < 3

1:6 %>% keep(greater_than_three)
1:6 %>% keep(less_than_three)


## ------------------------------------------------------------------------
1:6 %>% keep(partial(`<`, 3))


## ------------------------------------------------------------------------
`<`


## ------------------------------------------------------------------------
1:6 %>% keep(partial(`<`, e2 = 3))


## ------------------------------------------------------------------------
1:6 %>% map_dbl(partial(`+`, 2))
1:6 %>% map_dbl(partial(`-`, 1))
1:3 %>% map_dbl(partial(`-`, e1 = 4))
1:3 %>% map_dbl(partial(`-`, e2 = 4))


## ------------------------------------------------------------------------
1:3 %>%
    map_dbl(partial(`+`, 2)) %>%
    map_dbl(partial(`*`, 3))


## ------------------------------------------------------------------------
1:3 %>% map_dbl(
    compose(partial(`*`, 3), partial(`+`, 2))
)


## ------------------------------------------------------------------------
is_even <- function(x) x %% 2 == 0
1:6 %>% keep(is_even)


## ------------------------------------------------------------------------
1:6 %>% keep(function(x) x %% 2 == 0)


## ------------------------------------------------------------------------
is_even_lambda <- ~ .x %% 2 == 0
1:6 %>% keep(is_even_lambda)


## ------------------------------------------------------------------------
1:6 %>% keep(~ .x %% 2 == 0)


## ------------------------------------------------------------------------
f <- function(x) 2 * x
f <- 5
f(2)


## ------------------------------------------------------------------------
f <- function(x) 2 * x
g <- function() {
    f <- 5 # not a function
    f(2)   # will look for a function
}
g()


## ------------------------------------------------------------------------
1:4 %>% map_dbl(~ .x / 2)
1:3 %>% map_dbl(~ 2 + .x)
1:3 %>% map_dbl(~ 4 - .x)
1:3 %>% map_dbl(~ .x - 4)


## ------------------------------------------------------------------------
1:3 %>% map_dbl(~ 3 * (.x + 2))


## ------------------------------------------------------------------------
map2_dbl(1:3, 1:3, ~ .x + .y)


## ------------------------------------------------------------------------
list(1:3, 1:3, 1:3) %>% pmap_dbl(~ .1 + .2 + .3)

