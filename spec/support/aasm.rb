
RSpec::Matchers.define :transition_from do |from_state|
  match do |object|
    begin
      object.aasm.current_state = from_state
      result = object.send(@event.to_s)
      result && object.aasm.current_state == @to_state.to_s
    rescue => e
      false
    end
  end

  chain :to do |to_state|
    @to_state = to_state
  end

  chain :on_event do |event|
    @event = event
  end

  failure_message do |object|
    "expected to transition from #{@from_state} to #{@to_state} on event #{@event}"
  end
end