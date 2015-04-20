defmodule LastEpisode.Fetch do
  @valid_extensions [".avi", ".mkv", ".mov", ".mp4", ".m4p", ".m4v", ".wmv", ".rmvb"]

  @moduledoc """
  For now the program expects a path with each subfolder corresponding
  to one serie. A direct subfolder of the specified path can have any
  number of subfolder it wants.

  So, the expected folder structure is something like:

  path/
    series_1/
      episode_1
      episode_2
      episode_3_folder/
        episode_3
      ...
    series_2/
      episode_1
      episode_2_folder/
        episode_2
      ...

  Returns the last episode of each subfolder in specified path or
  'Episode not found' in case there is no video file in the subfolder.
  """

  def main(argv) do
    parse_options(argv)
    |> validate_options
    |> fetch_episodes
    |> Enum.each(&(IO.puts(&1)))
  end

  def parse_options(argv) do
    {args, _, _} = OptionParser.parse(argv, aliases: [p: :path])

    args[:path] || :help
  end

  defp validate_options(:help) do
    IO.puts 'Usage: last_episode -p <path>'
    System.halt(0)
  end

  defp validate_options(path) do
    if !File.dir?(path), do: validate_options(:help)
    path
  end

  def fetch_episodes(path) do
    path
    |> fetch_folders
    |> fetch_last_episodes
  end

  defp fetch_folders(path) do
    path
    |> Path.join("*")
    |> Path.wildcard
    |> Enum.filter(&(File.dir?(&1)))
  end

  defp fetch_last_episodes(folders) do
    folders
    |> Enum.map(&(fetch_last_episode(&1)))
  end

  defp fetch_last_episode(folder) do
    folder
    |> list_files
    |> Enum.filter(&(!File.dir?(&1) && valid_file_extension?(&1)))
    |> last_downloaded_file(folder)
  end

  defp list_files(folder) do
    files = folder
    |> File.ls!
    |> Enum.map(&(Path.absname(&1, folder)))

    sub_files = folder
    |> Path.join("**")
    |> Path.wildcard

    files ++ sub_files
  end

  defp valid_file_extension?(file) do
    Enum.member?(@valid_extensions, Path.extname(file))
  end

  defp last_downloaded_file([], folder) do
    "#{folder}\n  - Episode not found\n"
  end

  defp last_downloaded_file(files, folder) do
    last = files
    |> List.last
    |> Path.basename

    "#{folder}\n  - #{last}\n"
  end
end
