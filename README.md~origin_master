# soen363Project1
There are five tables 
* movies ((mid: number, title: varchar, year: number(4),rating: float, num_ratings: number))
* actors (mid: number, name: varchar,cast_position: number)
* genres (mid: number, genre: varchar)
* tags (mid: number, tid: integer)
* tag_names (tid: number, tag: varchar)

Constraints
* mid is PK of movies
* (mid, name) is PK of actors, mid also FK references to movies
* (mid, genre) is PK of genre, mid also FK references to movies
* tid is PK of tag_names
* (mid, tid) is PK of tags, mid also FK references to movies, tid also FK referencs to tag_names

For movies, rating and num_rating, values is NULL when the values is not provide.
For actors, name is UNKNOWN if the values is not provide, cannot use NULL since it is PK
