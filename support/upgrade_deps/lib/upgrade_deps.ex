defmodule UpgradeDeps do

  def main(args) do
    args |> parse_args |> process
  end

  defp parse_args(args) do
    {options, _, _} = OptionParser.parse(args,
      switches: [dir: :string]
    )
    options
  end

  def process([]) do
    IO.puts "No arguments given"
  end

  def process(options) do
    dir = options[:dir]
    package = "elm-community/elm-history"

    # Remove old version
    IO.puts "Removing old package from #{dir}"
    System.cmd("rm", ["-rf", "#{dir}/elm-stuff/packages/#{package}"])

    # System.cmd "sed", ["-i.bak", "\:#{package}:d", "elm-package.json"], cd: dir, into: IO.stream(:stdio, :line)

    # Remove line from elm-package.json
    full_path = "#{dir}/elm-package.json"
    temp_file = "#{full_path}.new"

    IO.puts "Removing dep from #{full_path}"
    File.stream!(full_path)
      |> Stream.filter(&(!String.contains?(&1, package)))
      |> Stream.into(File.stream!(temp_file))
      |> Stream.run

    System.cmd("rm", [full_path])
    System.cmd("mv", [temp_file, full_path])

    # Install new version
    IO.puts "Installing new version in #{dir}"
    System.cmd "elm", ["package", "install", package, "-y"] , cd: dir, into: IO.stream(:stdio, :line)
  end

end
