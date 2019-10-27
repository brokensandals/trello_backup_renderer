RSpec.describe TrelloBackupRenderer::Rendering do
  Card = TrelloBackupRenderer::Models::Card
  List = TrelloBackupRenderer::Models::List
  Board = TrelloBackupRenderer::Models::Board

  describe '.generate_board_html' do
    it 'generates html for the test board' do
      board = TrelloBackupRenderer.load_board_dir(TEST_BOARD_DIR)
      html = TrelloBackupRenderer.generate_board_html(board)
      # File.write('spec/test_board/test.html', html)

      expect(html).not_to be_nil
      expect(html).to include 'First List'
      expect(html).to include 'Empty List'
      expect(html).to include 'Third List'

      expect(html).to include 'Simple Card'
      expect(html).to include 'Card with All Supported Features'
      expect(html).to include 'Labeled Card'

      expect(html).to include '<img class="card-cover" src="' + TEST_COVER_RELATIVE_PATH + '"/>'

      expect(html).to include 'This card has a description.'

      expect(html).to include '<span font-color="green">Green Label</span>'
      expect(html).to include '<span font-color="yellow">Yellow Label</span>'
    end

    it 'excludes archived lists' do
      open_list = List.new(closed: false, name: 'Open List', pos: 1)
      archived_list = List.new(closed: true, name: 'Archived List', pos: 2)
      board = Board.new(lists: [open_list, archived_list])
      html = TrelloBackupRenderer.generate_board_html(board)

      expect(html).to include 'Open List'
      expect(html).not_to include 'Archived List'
    end

    it 'excludes archived cards' do
      open_card = Card.new(closed: false, name: 'Open Card', pos: 1)
      archived_card = Card.new(closed: true, name: 'Archived Card', pos: 2)
      list = List.new(closed: false, name: 'List', pos: 1, cards: [open_card, archived_card])
      board = Board.new(lists: [list])
      html = TrelloBackupRenderer.generate_board_html(board)

      expect(html).to include 'Open Card'
      expect(html).not_to include 'Archived Card'
    end

    it 'escapes html in card descriptions' do
      card = Card.new(name: 'Card', pos: 1, desc: 'Hello <p>How are you</p>')
      list = List.new(name: 'List', pos: 1, cards: [card])
      board = Board.new(lists: [list])
      html = TrelloBackupRenderer.generate_board_html(board)

      expect(html).not_to include 'Hello <p>How are you</p>'
      expect(html).to include 'Hello &lt;p&gt;How are you&lt;/p&gt;'
    end
  end
end