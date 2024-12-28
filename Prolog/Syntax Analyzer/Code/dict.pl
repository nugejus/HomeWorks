% Prepositions
prep(prep(about)) --> [about].
prep(prep(in)) --> [in].
prep(prep(at)) --> [at].
prep(prep(of)) --> [of].
prep(prep(to)) --> [to].
prep(prep(with)) --> [with].
prep(prep(above)) --> [above].
prep(prep(along)) --> [along].
prep(prep(after)) --> [after].
prep(prep(down)) --> [down].
prep(prep(by)) --> [by].
prep(prep(from)) --> [from].
prep(prep(for)) --> [for].

% Singular nouns
n(singular, n(boy)) --> [boy].
n(singular, n(girl)) --> [girl].
n(singular, n(man)) --> [man].
n(singular, n(woman)) --> [woman].
n(singular, n(book)) --> [book].
n(singular, n(passion)) --> [passion].
n(singular, n(paris)) --> [paris].
n(singular, n(country)) --> [country].
n(singular, n(bed)) --> [bed].
n(singular, n(house)) --> [house].
n(singular, n(computer)) --> [computer].
n(singular, n(picture)) --> [picture].
n(singular, n(screen)) --> [screen].
n(singular, n(butterfly)) --> [butterfly].
n(singular, n(laptop)) --> [laptop].
n(singular, n(window)) --> [window].
n(singular, n(wind)) --> [wind].
n(singular, n(fire)) --> [fire].
n(singular, n(water)) --> [water].
n(singular, n(year)) --> [year].
n(singular, n(east)) --> [east].
n(singular, n(garden)) --> [garden].
n(singular, n(dog)) --> [dog].
n(singular, n(time)) --> [time].

% Plural nouns
n(plural, n(boys)) --> [boys].
n(plural, n(girls)) --> [girls].
n(plural, n(men)) --> [men].
n(plural, n(women)) --> [women].
n(plural, n(books)) --> [books].
n(plural, n(passions)) --> [passions].
n(plural, n(countries)) --> [countries].
n(plural, n(beds)) --> [beds].
n(plural, n(houses)) --> [houses].
n(plural, n(computers)) --> [computers].
n(plural, n(pictures)) --> [pictures].
n(plural, n(screens)) --> [screens].
n(plural, n(butterflies)) --> [butterflies].
n(plural, n(laptops)) --> [laptops].
n(plural, n(windows)) --> [windows].
n(plural, n(winds)) --> [winds].
n(plural, n(fires)) --> [fires].
n(plural, n(waters)) --> [waters].
n(plural, n(years)) --> [years].
n(plural, n(gardens)) --> [gardens].
n(plural, n(dogs)) --> [dogs].
n(plural, n(times)) --> [times].

% Singular pronouns
p(singular, p(he)) --> [he].
p(singular, p(she)) --> [she].
p(singular, p(it)) --> [it].

% Plural pronouns
p(plural, p(i)) --> [i].
p(plural, p(you)) --> [you].
p(plural, p(they)) --> [they].
p(plural, p(we)) --> [we].

% Singular verbs
v(singular, v(likes)) --> [likes].
v(singular, v(loves)) --> [loves].
v(singular, v(eats)) --> [eats].
v(singular, v(cooks)) --> [cooks].
v(singular, v(thinks)) --> [thinks].
v(singular, v(sees)) --> [sees].
v(singular, v(watches)) --> [watches].
v(singular, v(writes)) --> [writes].
v(singular, v(drinks)) --> [drinks].
v(singular, v(sits)) --> [sits].
v(singular, v(stands)) --> [stands].
v(singular, v(hangs)) --> [hangs].
v(singular, v(visits)) --> [visits].
v(singular, v(reads)) --> [reads].
v(singular, v(flies)) --> [flies].
v(singular, v(blows)) --> [blows].
v(singular, v(makes)) --> [makes].
v(singular, v(takes)) --> [takes].
v(singular, v(walks)) --> [walks].
v(singular, v(plays)) --> [plays].

% Plural verbs
v(plural, v(like)) --> [like].
v(plural, v(love)) --> [love].
v(plural, v(eat)) --> [eat].
v(plural, v(cook)) --> [cook].
v(plural, v(think)) --> [think].
v(plural, v(see)) --> [see].
v(plural, v(watch)) --> [watch].
v(plural, v(write)) --> [write].
v(plural, v(drink)) --> [drink].
v(plural, v(sit)) --> [sit].
v(plural, v(stand)) --> [stand].
v(plural, v(hang)) --> [hang].
v(plural, v(visit)) --> [visit].
v(plural, v(read)) --> [read].
v(plural, v(fly)) --> [fly].
v(plural, v(blow)) --> [blow].
v(plural, v(make)) --> [make].
v(plural, v(take)) --> [take].
v(plural, v(walk)) --> [walk].
v(plural, v(play)) --> [play].

% Singular determiners(articles)
det(singular, det(the)) --> [the].
det(singular, det(a)) --> [a].
det(singular, det(this)) --> [this].

% Plural determiners(articles)
det(plural,det(all)) --> [all].
det(plural, det(every)) --> [every].

% Independent determiners(articles)
det(_, det(my)) --> [my].
det(_, det(your)) --> [your].
det(_, det(his)) --> [his].
det(_, det(her)) --> [her].
det(_, det(its)) --> [its].
det(_, det(our)) --> [our].
det(_, det(their)) --> [their].
det(_, det(that)) --> [that].


% Adjectives
adj(adj(beautiful)) --> [beautiful].
adj(adj(deep)) --> [deep].
adj(adj(good)) --> [good].
adj(adj(bad)) --> [bad].
adj(adj(awful)) --> [awful].
adj(adj(dead)) --> [dead].
adj(adj(alive)) --> [alive].
adj(adj(cool)) --> [cool].
adj(adj(hot)) --> [hot].
adj(adj(cold)) --> [cold].
adj(adj(red)) --> [red].
adj(adj(green)) --> [green].
adj(adj(blue)) --> [blue].
adj(adj(black)) --> [black].
adj(adj(white)) --> [white].
adj(adj(dark)) --> [dark].
adj(adj(bright)) --> [bright].
adj(adj(heavy)) --> [heavy].
adj(adj(light)) --> [light].
adj(adj(little)) --> [little].
adj(adj(big)) --> [big].
adj(adj(long)) --> [long].
adj(adj(short)) --> [short].

% Adverbs for verbs
adv(verb,adv(finally)) --> [finally].
adv(verb,adv(always)) --> [always].
adv(verb,adv(carefully)) --> [carefully].
adv(verb,adv(angrily)) --> [angrily].
adv(verb,adv(arrogantly)) --> [arrogantly].
adv(verb,adv(beautifully)) --> [beautifully].
adv(verb,adv(bravely)) --> [bravely].
adv(verb,adv(brightly)) --> [brightly].
adv(verb,adv(deeply)) --> [deeply].
adv(verb,adv(fully)) --> [fully].
adv(verb,adv(actually)) --> [actually].

% Adverb for adjectives
adv(adjective,adv(very)) --> [very].
adv(adjective,adv(totally)) --> [totally].
adv(adjective,adv(too)) --> [too].
adv(adjective,adv(just)) --> [just].
adv(adjective,adv(perfectly)) --> [perfectly].
adv(adjective,adv(so)) --> [so].
adv(adjective,adv(nearly)) --> [nearly].
adv(adjective,adv(entirely)) --> [entirely].
adv(adjective,adv(quite)) --> [quite].
adv(adjective,adv(absolutely)) --> [absolutely].
adv(adjective,adv(pretty)) --> [pretty].