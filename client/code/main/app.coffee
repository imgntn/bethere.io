# Client Side code

scene = require 'scene'

window.sc =
  user: null
  myCube: null
  cubes: {}

# wait for server to send us a cube
ss.event.on 'initCube', (cube) ->
  console.log 'recieved cube'
  
  # getting clients cubes
  if cube.name == sc.user
    console.log 'my cube'
    initCube(cube)
  # getting others cubes
  else
    console.log 'their cube'
    sc.cubes[cube.name] = initCar(car)
    
# return existing cube or
# create a new cube and add it to the scene
initCube = (cube) ->
  console.log 'initializing cube'
  # TODO create cube or grab existing cube
  ###
  for tc in sc.cubes
    if tc.id is cube.id
      return tc
      
  if sc.myCube? and sc.myCube.id is cube.id
    return sc.myCube
  ###
      
# show the login page
displaySignIn = ->
  
  # sign in submition
  $('#signIn').show().submit ->
    console.log "submitting username"
    
    #store username globablly
    sc.user = $('#signIn').find('input').val()
    
    # ask server to log in
    ss.rpc "auth.signIn", sc.user, (response) ->
      
      # error if user already exists
      if response.error
        console.log "response error"
        $('#signIn').find('input').val('')
        $('#signIn').append("<p id='signInError'>" + response.error_msg + "</p>")
        
      # fadeOut login and show scene
      else
        $('#signIn').fadeOut(230)
        displayScene()
        
    # stop submit button from continuing
    false
    
# initialize the canvas and scene and show main view
displayScene = ->
  console.log "displaying scene"
  setupCanvas()
  $('#main').show()
  
setupCanvas = ->
  console.log "setting up canvas"
  console.log "initializing"
  if not scene.init()
    scene.animate()
  else
    console.log "did not init"
  
  
initialized = false

init = ->
  initialized = true
  # ask server if I am logged in
  ss.rpc "auth.init", (user) ->
    # logged in
    if user
      console.log "signed in"
      displayScene() 
      
    # not logged in
    else 
      console.log "not signed in"
      displaySignIn()


SocketStream.event.on 'ready', ->
  console.log "socket stream ready"
  init()

init() unless initialized


