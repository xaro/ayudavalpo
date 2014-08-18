Parse.initialize("8l96HZhH4ni8Dy3eY1FyrmlamH6Rcsw8C2TRUawD", "dgX1qaRqzbHKJUWKnF9gEFrWd67JHLTAGfeMIGCn")
$(document).foundation()
moment.lang("es")

Place = Parse.Object.extend("Place")
Comment = Parse.Object.extend("Comment")

placesCollection = null
commentsCollection = null

query = new Parse.Query(Place)
query.descending("updatedAt")
updatePlaces = ->
  query.find
    success: (places) ->
      placesCollection = places
      ayudaViewModel.places.removeAll()
      for place in places
        ayudaViewModel.places.push
          id: place.id
          createdAt: place.createdAt
          name: place.get("name")
          safeName: URLify(place.get("name"))
          address: place.get("address")
    error: (error) ->
      console.error error

commentsQuery = new Parse.Query(Comment)
commentsQuery.descending("createdAt").include("place")
updateComments = ->
  commentsQuery.find
    success: (comments) ->
      commentsCollection = comments
      ayudaViewModel.comments.removeAll()
      for comment in comments
        ayudaViewModel.comments.push
          id: comment.id
          createdAt: comment.createdAt
          content: Autolinker.link(comment.get("content"))
          status: comment.get("status")
          phone: comment.get("phone")
          email: comment.get("email")
          humanCreatedAt: moment(comment.createdAt).fromNow()
          place: if comment.get("place")? then comment.get("place").get("name") else ""
    error: (error) ->
      console.error error

ayudaViewModel =
  places: ko.observableArray()
  comments: ko.observableArray()
  saveComment: (form) ->
    $form = $(form)
    comment = new Comment()
    comment.set "content", $form.find(".content").val()
    comment.set "status", $form.find(".status").val()
    comment.set "phone", $form.find(".phone").val()
    comment.set "email", $form.find(".email").val()

    placeId = $form.find(".place").val()
    place = (placesCollection.filter (p) -> p.id == placeId)[0]

    comment.set "place", place
    comment.save().then (->
      updateComments()
      $form.parents(".reveal-modal").foundation('reveal', 'close')
    ), ((error) -> console.error(error))

ko.applyBindings(ayudaViewModel)
updatePlaces()
updateComments()
