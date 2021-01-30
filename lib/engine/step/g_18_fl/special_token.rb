# frozen_string_literal: true

require_relative '../special_token'

module Engine
  module Step
    module G18FL
      class SpecialToken < SpecialToken

        def actions(entity)
          return [] unless could_lay_token

          %w[place_token pass]
        end

        def description
          'tokeno'
        end

        def pass_description
          'passo'
        end

        def could_lay_token
          return false if @game.terminal_co.closed?
          @game.current_entity.owner == @game.terminal_co.owner
        end

        def process_place_token(action)
          entity = action.entity

          hex = action.city.hex
          city_string = hex.tile.cities.size > 1 ? " city #{action.city.index}" : ''
          raise GameError, "Cannot place token on #{hex.name}#{city_string}" unless available(hex)

          place_token(
            @game.current_entity,
            action.city,
            action.token,
            teleport: ability(@game.terminal_co).teleport_price,
            special_ability: ability(@game.terminal_co),
          )
        end

        def available(hex)
          entity = @game.terminal_co
          return if ability(entity).hexes.any? && !ability(entity).hexes.include?(hex.id)
  
          @game.hex_by_id(hex.id).neighbors.keys
        end

        def available_tokens(entity)
          [Engine::Token.new(@game.current_entity)]
        end
      end
    end
  end
end