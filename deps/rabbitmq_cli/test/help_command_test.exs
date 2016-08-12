## The contents of this file are subject to the Mozilla Public License
## Version 1.1 (the "License"); you may not use this file except in
## compliance with the License. You may obtain a copy of the License
## at http://www.mozilla.org/MPL/
##
## Software distributed under the License is distributed on an "AS IS"
## basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
## the License for the specific language governing rights and
## limitations under the License.
##
## The Original Code is RabbitMQ.
##
## The Initial Developer of the Original Code is GoPivotal, Inc.
## Copyright (c) 2007-2016 Pivotal Software, Inc.  All rights reserved.


defmodule HelpCommandTest do
  use ExUnit.Case, async: false
  import ExUnit.CaptureIO

  alias RabbitMQ.CLI.Ctl.Helpers, as: Helpers

  @command RabbitMQ.CLI.Ctl.Commands.HelpCommand

  setup_all do
    :ok
  end

  test "basic usage info is printed" do
    assert capture_io(fn -> @command.run([], %{}) end) =~ ~r/Default node is \"rabbit@server\"/
  end

  test "command usage info is printed if command is specified" do
    Helpers.commands
    |>  Map.keys
    |>  Enum.each(
          fn(command) -> assert capture_io(
            fn -> @command.run([command], %{}) end
          ) =~ ~r/#{command}/
        end)
  end

  test "Command info is printed" do
    assert capture_io(fn -> @command.run([], %{}) end) =~ ~r/Commands:\n/

    # Checks to verify that each module's command appears in the list.
    Helpers.commands
    |>  Map.keys
    |>  Enum.each(
          fn(command) -> assert capture_io(
            fn -> @command.run([], %{}) end
          ) =~ ~r/\n    #{command}.*\n/
        end)
  end

  test "Info items are defined for existing commands" do
    assert capture_io(fn -> @command.run([], %{}) end) =~ ~r/\n\<vhostinfoitem\> .*\n/
    assert capture_io(fn -> @command.run([], %{}) end) =~ ~r/\n\<queueinfoitem\> .*\n/
    assert capture_io(fn -> @command.run([], %{}) end) =~ ~r/\n\<exchangeinfoitem\> .*\n/
    assert capture_io(fn -> @command.run([], %{}) end) =~ ~r/\n\<bindinginfoitem\> .*\n/
    assert capture_io(fn -> @command.run([], %{}) end) =~ ~r/\n\<connectioninfoitem\> .*\n/
    assert capture_io(fn -> @command.run([], %{}) end) =~ ~r/\n\<channelinfoitem\> .*\n/
  end

  test "Info items are printed for selected command" do
    assert capture_io(fn -> @command.run(["list_vhosts"], %{}) end) =~ ~r/\n\<vhostinfoitem\> .*\n/
    assert capture_io(fn -> @command.run(["list_queues"], %{}) end) =~ ~r/\n\<queueinfoitem\> .*\n/
    assert capture_io(fn -> @command.run(["list_exchanges"], %{}) end) =~ ~r/\n\<exchangeinfoitem\> .*\n/
    assert capture_io(fn -> @command.run(["list_bindings"], %{}) end) =~ ~r/\n\<bindinginfoitem\> .*\n/
    assert capture_io(fn -> @command.run(["list_connections"], %{}) end) =~ ~r/\n\<connectioninfoitem\> .*\n/
    assert capture_io(fn -> @command.run(["list_channels"], %{}) end) =~ ~r/\n\<channelinfoitem\> .*\n/
  end

  test "No arguments also produce help command" do
    assert capture_io(fn -> @command.run([], %{}) end) =~ ~r/Usage:/
  end

  test "Extra arguments also produce help command" do
    assert capture_io(fn -> @command.run(["extra1", "extra2"], %{}) end) =~ ~r/Usage:/
  end  
end
