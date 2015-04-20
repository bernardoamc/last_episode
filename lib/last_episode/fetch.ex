defmodule LastEpisode.Fetch do
  @valid_extensions [".avi", ".mkv", ".mov", ".mp4", ".m4p", ".m4v", ".wmv", ".rmvb"]

  @moduledoc """
  Returns the last episode in the specified folder or subfolder.

  The expected structure of the searched path is:

  path
    series_1
      episode_1
      episode_2
      ...
    series_2
      episode_1
      ...

  Returns the last episode of the specified path or the last episode of each
  subfolder in the specified path.
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
