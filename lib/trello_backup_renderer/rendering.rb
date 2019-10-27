require 'erb'

module TrelloBackupRenderer
  module Rendering
    BOARD_HTML_TEMPLATE = File.read(File.join(__dir__, 'templates', 'board.html.erb'))

    class BoardPage
      def initialize(board)
        @board = board
      end

      def lists
        @board.lists.reject(&:closed).map { |list| ListPresenter.new(list) }
      end

      def render
        ERB.new(BOARD_HTML_TEMPLATE).result(binding)
      end
    end

    class ListPresenter < SimpleDelegator
      def cards
        super.reject(&:closed).map { |card| CardPresenter.new(card) }
      end

      def name
        ERB::Util.h(super)
      end
    end

    class CardPresenter < SimpleDelegator
      def desc
        ERB::Util.h(super) if super
      end

      def labels
        super.map { |label| LabelPresenter.new(label) }
      end

      def name
        ERB::Util.h(super)
      end
    end

    class LabelPresenter < SimpleDelegator
      def name
        ERB::Util.h(super)
      end
    end

    def generate_board_html(board)
      BoardPage.new(board).render
    end
  end
end