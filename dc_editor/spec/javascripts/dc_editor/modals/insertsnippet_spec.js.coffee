describe "DcEditor.modalHandlers.insertSnippet", ->

  template 'dc_editor/modals/insertsnippet.html'

  beforeEach ->
    DcEditor.Snippet.all = []
    DcEditor.Snippet.load({
      'snippet_0': {name: 'foo', options: {'first_name': "Jeremy", 'last_name': "Jackson"}},
    })
    @modal =
      element: $('#test')
      hide: ->
      options: {snippetName: 'test'}
    DcEditor.modalHandlers.insertSnippet.call(@modal)

  describe "submitting", ->

    it "hides the modal", ->
      spy = spyOn(@modal, 'hide').andCallFake(=>)
      jasmine.simulate.click($('#submit').get(0))
      expect(spy.callCount).toEqual(1)

    describe "if there's an active snippet", ->

      beforeEach ->
        DcEditor.snippet = DcEditor.Snippet.all[0]

      it "updates the snippet", ->
        spy = spyOn(DcEditor.Snippet.prototype, 'setOptions').andCallThrough()
        jasmine.simulate.click($('#submit').get(0))
        expect(spy.callCount).toEqual(1)
        expect(DcEditor.Snippet.all[0]['options']).toEqual({first_name: 'Wilma', last_name: 'Flintstone'})

      it "triggers an action", ->
        spy = spyOn(DcEditor, 'trigger').andCallFake(=>)
        jasmine.simulate.click($('#submit').get(0))
        expect(spy.callCount).toEqual(1)
        expect(spy.argsForCall[0]).toEqual(['action', {action: 'insertSnippet', value: DcEditor.Snippet.all[0]}])

    describe "if there's no active snippet", ->

      it "creates a snippet", ->
        spy = spyOn(DcEditor.Snippet, 'create').andCallThrough()
        jasmine.simulate.click($('#submit').get(0))
        expect(spy.callCount).toEqual(1)
        expect(DcEditor.Snippet.all[1]['options']).toEqual({first_name: 'Wilma', last_name: 'Flintstone'})

      it "triggers an action", ->
        spy = spyOn(DcEditor, 'trigger').andCallFake(=>)
        jasmine.simulate.click($('#submit').get(0))
        expect(spy.callCount).toEqual(1)
        expect(spy.argsForCall[0]).toEqual(['action', {action: 'insertSnippet', value: DcEditor.Snippet.all[1]}])
