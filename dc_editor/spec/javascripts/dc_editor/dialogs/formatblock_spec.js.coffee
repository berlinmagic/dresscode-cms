describe "DcEditor.dialogHandlers.formatblock", ->

  template 'dc_editor/dialogs/formatblock.html'

  beforeEach ->
    @dialog = {element: $('#test')}
    DcEditor.dialogHandlers.formatblock.call(@dialog)

  describe "when an element with a data-tag attribute is clicked", ->

    it "triggers an action", ->
      spy = spyOn(DcEditor, 'trigger').andCallFake(=>)
      jasmine.simulate.click($('#h1').get(0))
      expect(spy.callCount).toEqual(1)
      expect(spy.argsForCall[0]).toEqual(['action', {action: 'formatblock', value: 'h1'}])
      jasmine.simulate.click($('#div').get(0))
      expect(spy.argsForCall[1]).toEqual(['action', {action: 'formatblock', value: 'pre'}])


  describe "when any other element is clicked", ->

    it "does nothing", ->
      spy = spyOn(DcEditor, 'trigger').andCallFake(=>)
      jasmine.simulate.click($('#em').get(0))
      expect(spy.callCount).toEqual(0)
