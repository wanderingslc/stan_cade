namespace :soork do
  desc "Play a Soork adventure"
  task play: :environment do
    require 'io/console'

    all_soorks = Soork.select(:id, :title)
    continue = false
    until continue
      print "Available Soorks:  \n"
      all_soorks.each do |soork|
        print "#{soork.id}: #{soork.title}\n"
      end

      print "Enter Soork ID: "
      soork_id = STDIN.gets.chomp

      if soork_id == 'q'
        exit
      end

      if  all_soorks.any? {|soork| soork.id == soork_id.to_i}

        soork = Soork.find(soork_id)
        continue = true
      else
        print "Invalid Soork ID. Please try again, or type q to quit \n"
      end
    end

    start_room = soork.rooms.find_by(start_room: true)

    if start_room.nil?
      puts "Error: This Soork has no starting room!"
      exit
    end

    player = SoorkPlayer.create!(
      soork: soork,
      current_room: start_room,
      game_state_flags: {}
    )

    cli = SoorkCli.new(player)
    cli.start
  end
end