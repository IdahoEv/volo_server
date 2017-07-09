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

  @list_max_length 20 
             
  @doc """
  beat should be a %Heartbeat{}.  
  
  reply should be a map containing a key for client_time.
  
  received_at should be a timestamp when the server first received
  the reply.
  """          
  def update_with_reply(beat, reply, received_at) do
    %__MODULE__{ beat | 
      client_time: reply.client_time,
      rtt: received_at - beat.sent,
      reply_received: received_at       
    }
  end 
  
  @doc """
  Adds a heartbeat to a list, keeping the list within max length
  
  TODO: Improve performance by finding only the first match and splicing it.
  It'll usually be the first in the list, so no need to iterate
  """
  def append_to_list(list, beat) do
    Enum.slice([ beat | list ],0..(@list_max_length - 1))
  end
  
  def update_list_with_reply(list, reply, received_at) do
    new_list = for beat <- list do
      if beat.id == reply.id do
        update_with_reply(beat, reply, received_at)
      else
        beat
      end      
    end
    new_list
  end
end