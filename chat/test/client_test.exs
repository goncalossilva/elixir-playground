defmodule ClientTest do
  use ExUnit.Case

  # test "nickname is broadcast" do
  #   port = 4040
  #   Task.async(Tcp, :listen, port: port)
  #   opts = [:binary, packet: :line, active: false, reuseaddr: true]
  #   {:ok, socket} = :gen_tcp.connect('127.0.0.1', port, opts)
  #   Client.init(self(), socket)
  #   Tcp.write_line(socket, "Test")

  #   assert_received 1
  # end
end
