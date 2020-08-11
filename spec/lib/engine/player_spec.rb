# frozen_string_literal: true

require './spec/spec_helper'
require 'engine/player'
require 'engine/game/g_1889'

module Engine
  describe Player do
    let(:players) { %w[a b c].map { |p| [p, p] }.to_h }
    let(:game) { Game::G1889.new(players) }
    let(:corporation) { game.corporations.first }
    let(:company) { game.companies.first }
    let(:share_pool) { game.share_pool }
    let(:player) { game.player_by_id('a') }
    let(:market) { game.stock_market }

    describe '#num_certs' do
      it 'privates' do
        expect(player.num_certs).to eq(0)
        player.companies << company
        expect(player.num_certs).to eq(1)
      end

      it 'shares' do
        current_price = market.market[0][0]
        market.set_par(corporation, current_price)
        share_pool.buy_shares(player, corporation.shares[0])
        expect(player.num_certs).to eq(1)
      end

      it 'privates and shares' do
        player.companies << company
        current_price = market.market[0][0]
        market.set_par(corporation, current_price)
        share_pool.buy_shares(player, corporation.shares[0])
        expect(player.num_certs).to eq(2)
      end

      it 'non-limit shares' do
        current_price = market.market[-1][0]
        market.set_par(corporation, current_price)
        share_pool.buy_shares(player, corporation.shares[0])
        expect(player.num_certs).to eq(0)
      end
    end
  end
end
