angular.module('flipflops.content.blog.post.controller', [
    'ui.router'
    'flipflops.site'
    'flipflops.renderer'
]).controller 'BlogPostCtrl', ($scope, Site, $stateParams, Renderer, $sce, $state)->
    $scope.content = ''
    path = "/posts/#{$stateParams.blogPath}"
    Site.loaded.then ->
        file = Site.find path
        $scope.front = file.front
        file.front.date = new Date file.front.date

        link file

        Renderer.render(file.body).then (content)->
            $scope.content = $sce.trustAsHtml content

        $scope.$on 'NEXT!', ->
            if $scope.next
                console.log "Going to the next page."
                $state.go 'blog.post',
                    pagePath: Site.link $scope.next.path
        $scope.$on 'PREVIOUS!', ->
            if $scope.previous
                $state.go 'blog.post',
                    pagePath: Site.link $scope.previous.path

    link = (file)->
        index = Site.index.posts.indexOf file.path
        if index > 0
            $scope.previous = Site.files[Site.index.posts[index - 1]]
        if index < Site.index.posts.length - 1
            $scope.next = Site.files[Site.index.posts[index + 1]]
