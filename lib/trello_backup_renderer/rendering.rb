require 'erb'

module TrelloBackupRenderer
  module Rendering
    BOARD_HTML_TEMPLATE = File.read(File.join(__dir__, 'templates', 'board.html.erb'))
    CSS_FILE = File.read(File.join(__dir__, 'styles', 'default.css'))
    NO_AUTHORSHIP_CSS_FILE = File.read(File.join(__dir__, 'styles', 'no-authorship.css'))

    class BoardPage
      def initialize(board)
        @board = board
      end

      def lists
        @board.lists.reject(&:closed).map { |list| ListPresenter.new(list) }
      end

      def stylesheet_tags
        '<style type="text/css">' + CSS_FILE + '</style>' +
          '<style type="text/css">' + NO_AUTHORSHIP_CSS_FILE + '</style>'
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

      def comments
        super.map { |comment| CommentPresenter.new(comment) }
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

    class CommentPresenter < SimpleDelegator
      def creator_full_name
        ERB::Util.h(super)
      end

      def text
        ERB::Util.h(super)
      end
    end

    def generate_board_html(board)
      BoardPage.new(board).render
    end
  end
end