# frozen_string_literal: true

require_relative '../base'

module Engine
  module Step
    module G1828
      class SwapTrain < Base
        def actions(entity)
          actions = []
          return actions if !entity.system? || entity.trains.none?

          actions << 'swap_train'
          actions << 'pass' unless over_train_limit?(entity)
          actions
        end

        def description
          'Arrange Trains Between Shells'
        end

        def pass_description
          'Done'
        end

        def pass!
          @round.ignore_train_limit = false
          super
        end

        def process_swap_train(action)
          train = action.train
          entity = action.entity
          @game.game_error('Only systems can swap trains') unless entity.system?
          @game.game_error("Train not owned by #{action.entity.name}") unless train.owner == entity

          current_shell = entity.shells.find { |shell| shell.trains.include?(train) }
          current_shell.trains.delete(train)

          new_shell = entity.shells.find { |shell| shell != current_shell }
          new_shell.trains << train

          @log << "#{entity.name} swaps #{train.name} from #{current_shell.name} shell to #{new_shell.name} shell"

          @round.ignore_train_limit = true
        end

        def over_train_limit?(entity)
          entity.shells.any? { |shell| shell.trains.size > @game.phase.train_limit(entity) }
        end
      end
    end
  end
end
