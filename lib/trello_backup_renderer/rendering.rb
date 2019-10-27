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
        super.reject(&:closed)
      end
    end

    def generate_board_html(board)
      BoardPage.new(board).render
    end
  end
end