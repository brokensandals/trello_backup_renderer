require 'erb'

module TrelloBackupRenderer
  module Rendering
    BOARD_HTML_TEMPLATE = File.read(File.join(__dir__, 'templates', 'board.html.erb'))
    CSS_FILE = File.read(File.join(__dir__, 'styles', 'default.css'))
    NO_AUTHORSHIP_CSS_FILE = File.read(File.join(__dir__, 'styles', 'no-authorship.css'))

    class Options
      attr_reader :hide_authorship
      attr_reader :omit_styles
      attr_reader :head_insert

      def initialize(args = {})
        @hide_authorship = args[:hide_authorship]
        @omit_styles = args[:omit_styles]
        @head_insert = args[:head_insert]
      end
    end

    class BoardPage
      def initialize(board, options)
        @board = board
        @options = options
      end

      def lists
        @board.lists.reject(&:closed).map { |list| ListPresenter.new(list) }
      end

      def stylesheet_tags
        tags = ''
        tags << '<style type="text/css">' + CSS_FILE + '</style>' unless @options.omit_styles
        tags << '<style type="text/css">' + NO_AUTHORSHIP_CSS_FILE + '</style>' if @options.hide_authorship
        tags
      end

      def head_insert
        @options.head_insert || ''
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

    def generate_board_html(board, options = Options.new)
      BoardPage.new(board, options).render
    end
  end
end