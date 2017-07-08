defmodule HeartbeatTest do
  use ExSpec, async: true

  alias Volo.Web.Heartbeat
  doctest Volo.Web.Heartbeat
  
  describe "update_with_reply" do
    it "adds the client time to the heartbeat" do
      beat = %Heartbeat{ id: "foo", "sent": 1234.56 }
      new_beat = Heartbeat.update_with_reply(
       beat,
        %{ client_time: 1234.67 },
        1234.78
      )
      assert new_beat.client_time == 1234.67      
    end
    
    it "computes the RTT" do
      beat = %Heartbeat{ id: "foo", "sent": 1234.56 }
      new_beat = Heartbeat.update_with_reply(
       beat,
        %{ client_time: 1234.67 },
        1234.78
      )
      assert_in_delta(new_beat.rtt, 0.22, 0.01)      
    end    
  end
end  