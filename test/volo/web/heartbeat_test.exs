defmodule HeartbeatTest do
  use ExSpec, async: true

  alias Volo.Web.Heartbeat
  doctest Volo.Web.Heartbeat
  
  describe "update_with_reply" do
    it "adds the client time and received time to the heartbeat" do
      beat = %Heartbeat{ id: "foo", "sent": 1234.56 }
      new_beat = Heartbeat.update_with_reply(
       beat,
        %{ "client_time" => 1234.67 },
        1234.78
      )
      assert new_beat.client_time == 1234.67      
      assert new_beat.reply_received == 1234.78      
    end
    
    it "computes the RTT" do
      beat = %Heartbeat{ id: "foo", "sent": 1234.56 }
      new_beat = Heartbeat.update_with_reply(
       beat,
        %{ "client_time" => 1234.67 },
        1234.78
      )
      assert_in_delta(new_beat.rtt, 0.22, 0.01)      
    end    
  end
  
  describe "append_to_list" do
    it "adds to an empty list" do
      list = []
      beat = %Heartbeat{ id: "foo", "sent": 1234.56 }
      new_list = Heartbeat.append_to_list(list, beat)
      assert length(new_list) == 1
      assert List.first(new_list) == beat
    end
        
    it "adds to a non-empty list" do
      list = [ %Heartbeat{ id: "foo", "sent": 1234.56 } ]
      beat = %Heartbeat{ id: "foo1", "sent": 1235.56 }
      new_list = Heartbeat.append_to_list(list, beat)
      assert length(new_list) == 2
      assert List.first(new_list) == beat
    end    
    
    it "limits the length of the list" do
      list = for nn <- 1..19 do 
        %Heartbeat{ id: "foo#{nn}", "sent": 1000.00 + nn } 
      end
      
      list = Heartbeat.append_to_list(list, %Heartbeat{ id: "bar1", sent: 1235.56 } )
      assert length(list) == 20
      beat = %Heartbeat{ id: "bar2", "sent": 1236.56 }
      list = Heartbeat.append_to_list(list, beat )
      assert length(list) == 20
      assert List.first(list) == beat
    end    
  end
  
  describe "update_list_with_reply" do
    it "updates the entry matching the supplied ID" do
      list = for nn <- 1..5 do 
        %Heartbeat{ id: "foo#{nn}", "sent": 1000.00 + nn } 
      end
      list = Heartbeat.update_list_with_reply(list, 
        %{ "client_time" => 1025.67, "id" => "foo3" },
        1005.67
      )
      beat = list |> Enum.find(fn(bb) -> bb.id == "foo3" end)
      assert beat.client_time == 1025.67
      assert_in_delta beat.rtt, 2.67, 0.01
      assert_in_delta beat.reply_received, 1005.67, 0.01
    end
  end
  
  describe "average_rtt" do
    it "is correct for a set of heartbeats" do
      list = for nn <- 1..5 do 
        %Heartbeat{ id: "foo#{nn}", rtt: 0.100 } 
      end
      avg = Heartbeat.average_rtt(list)
      assert( avg == 0.100)
    end
    
    it "is correct when nil values are included" do
      list = [
        %Heartbeat{ id: "foo1", rtt: 0.100 },
        %Heartbeat{ id: "foo2", rtt: nil },
        %Heartbeat{ id: "foo3", rtt: 0.300 },         
      ]
      avg = Heartbeat.average_rtt(list)
      assert_in_delta( avg, 0.200, 0.01)
    end
    
    it "is zero when no all rtts are nil" do
      list = [
        %Heartbeat{ id: "foo1", rtt: nil },
        %Heartbeat{ id: "foo2", rtt: nil },
        %Heartbeat{ id: "foo3", rtt: nil },         
      ]
      avg = Heartbeat.average_rtt(list)
      assert_in_delta( avg, 0.00, 0.01)      
    end
  end
end  