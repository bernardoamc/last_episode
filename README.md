LastEpisode
===========

This is a small project in Elixir to fetch the last episode in each folder
inside the specified path.

To package this program you need to execute:

`mix escript.build`

After this you just need to run:

`./last_episode -p <path>`

For now the program expects a path with each subfolder corresponding
to one serie. A direct subfolder of the specified path can have any
number of subfolder it wants.

So, the expected folder structure is something like:

```
Series/
  Serie X/
    - episode_1
    - episode_2
    - episode_3_folder/
      - episode_3
    - ...
  Serie Y/
    - episode_1
    episode_2_folder/
      - episode_2
    - ...
```

If you run `./last_episode -p series_path` you will get:

```
series_path/Series X
  - name_of_the_last_episode_in_this_folder

series_path/Series Y
  - name_of_the_last_episode_in_this_folder
```
