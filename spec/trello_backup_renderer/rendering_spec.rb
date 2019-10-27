RSpec.describe TrelloBackupRenderer::Rendering do
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
      puts html
    end

    it 'excludes archives lists' do
      open_list = List.new(closed: false, name: 'Open List', pos: 1)
      archived_list = List.new(closed: true, name: 'Archived List', pos: 2)
      board = Board.new(lists: [open_list, archived_list])
      html = TrelloBackupRenderer.generate_board_html(board)

      expect(html).to include 'Open List'
      expect(html).not_to include 'Archived List'
    end
  end
end