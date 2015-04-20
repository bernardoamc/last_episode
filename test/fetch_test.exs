defmodule FetchTest do
  use ExUnit.Case

  import LastEpisode.Fetch, only: [fetch_episodes: 1, parse_options: 1]

  test ":help returned when -p or --path is not specified" do
    assert parse_options([]) == :help
    assert parse_options(["--wrong", "anything"]) == :help
  end

  test "fetch_episodes returns the list of last written video files in path" do
    create_files
    last_episodes = fetch_episodes("/tmp/series")

    assert "/tmp/series/arrow\n  - episode2.avi\n" in last_episodes
    assert "/tmp/series/flash\n  - episode1.avi\n" in last_episodes
  end

  test "fetch_episodes informs the user when an episode could not be found in a folder" do
    create_files
    last_episodes = fetch_episodes("/tmp/series")

    assert "/tmp/series/house_of_cards\n  - Episode not found\n" in last_episodes
  end

  defp create_files do
    File.mkdir_p!("/tmp/series")
    File.mkdir_p!("/tmp/series/arrow")
    File.mkdir_p!("/tmp/series/flash")
    File.mkdir_p!("/tmp/series/house_of_cards")

    File.write!(Path.join("/tmp/series/arrow", "episode1.avi"), "xxx")
    File.write!(Path.join("/tmp/series/arrow", "episode2.avi"), "xxx")
    File.write!(Path.join("/tmp/series/flash", "episode1.avi"), "xxx")
  end
end
