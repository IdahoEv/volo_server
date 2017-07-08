defmodule Volo.Web.Heartbeat do
  
  import Apex.AwesomeDef

  @moduledoc """
  A record of a heartbeat sent to (and possibly reply received from)
  the client.  Used to keep tabs on whether the connection is live,
  and to measure the roundtrip message time.
  """

  defstruct  id:             "", # Unique ID to associate the ping with the pong
             sent:           "", # Server time when the ping was sent
             reply_received: "", # Server time when the reply was received
             client_time:    "", # Time on the client when the reply was sent
             rtt:            ""  # total round trip time

  @doc """
  beat should be a %Heartbeat{}.  
  
  reply should be a map containing a key for client_time.
  
  received_at should be a timestamp when the server first received
  the reply.
  """          
  def update_with_reply(beat, reply, received_at) do
    %__MODULE__{ beat | 
      client_time: reply.client_time,
      rtt: received_at - beat.sent       
    }
  end 
end