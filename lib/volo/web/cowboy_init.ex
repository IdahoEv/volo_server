defmodule Volo.Web.CowboyInit do
  import Apex.AwesomeDef
  alias Volo.Web.WebsocketHandler

  def start(_type, [game_pid]) do
    dispatch_config = build_dispatch_config(game_pid)
    { :ok, _ } = :cowboy.start_http(:http,
                                    100,
                                   [{:port, 8080}],
                                   [{ :env, [{:dispatch, dispatch_config}]}]
                                   )

  end

  def build_dispatch_config(game_pid) do
    :cowboy_router.compile([
      { :_, [ {"/websocket", WebsocketHandler, [game_pid]} ]}
    ])
  end
end
