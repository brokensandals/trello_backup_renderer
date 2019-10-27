RSpec.describe TrelloBackupRenderer::Rendering do
  Card = TrelloBackupRenderer::Models::Card
  List = TrelloBackupRenderer::Models::List
  Board = TrelloBackupRenderer::Models::Board

  describe '.generate_board_html' do
    it 'generates html for the test board' do
      board = TrelloBackupRenderer.load_board_dir(TEST_BOARD_DIR)
      html = TrelloBackupRenderer.generate_board_html(board)

      expect(html).not_to be_nil
      expect(html).to include '<h1>First List</h1>'
      expect(html).to include '<h1>Empty List</h1>'
      expect(html).to include '<h1>Third List</h1>'

      expect(html).to include '<h1>Simple Card</h1>'
      expect(html).to include '<h1>Card with All Supported Features</h1>'
      expect(html).to include '<h1>Labeled Card</h1>'
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
  end
end