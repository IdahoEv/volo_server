defmodule Volo.Util.Time do

  # float seconds ince the epoch, using :os.timestapm
  def now do
    float_seconds(:os.timestamp)
  end

  def float_seconds(ts) do
    ( elem(ts, 0) * 1000000.0 ) +
    ( elem(ts, 1) ) +
    ( elem(ts, 2) / 1000000.0 )
  end

  def delta(old_time) do
    delta(now, old_time)
  end

  def delta(new_time, old_time) do
    { new_time - old_time, new_time }
  end
end
