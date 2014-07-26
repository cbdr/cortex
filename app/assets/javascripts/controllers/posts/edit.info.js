angular.module('cortex.controllers.posts.edit.info', [
  'cortex.services.cortex',
  'cortex.filters',
  'cortex.util',
  'cortex.directives.showErrors'
])

.controller('PostsEditInfoCtrl', function($scope, $filter, cortex, delayedBind, currentUser) {
  // Auto-generate slug when title changed and field isn't dirty
  $scope.$watch('data.post.title', function(title) {
    if ($scope.postForm.slug.$dirty && $scope.postForm.slug) {
      return;
    }
    $scope.data.post.slug = $filter('slugify')(title);
  });

  $scope.$watch('data.authorIsUser', function(authorIsUser) {
    if (authorIsUser) {
      $scope.data.post.custom_author = currentUser.firstname + ' ' + currentUser.lastname;
    }
  });

  function slugCheck() {
    var slug = $scope.data.post.slug;
    if (!slug || !postForm.slug) {
      return;
    }

    cortex.posts.get({id: slug},
        // Slug already used
        function(post) {

          // A post may have its own slug
          if (post.id === $scope.data.post.id) {
            $scope.postForm.slug.$error.unavailable = false;
            $scope.data.postWithDuplicateSlug = null;
          }
          else {
            $scope.postForm.slug.$error.unavailable = true;
            $scope.data.postWithDuplicateSlug = post;
          }
        },
        // Slug unused
        function() {
          $scope.postForm.slug.$error.unavailable = false;
          $scope.data.postWithDuplicateSlug = null;
        }
    );
  }
  delayedBind($scope, 'data.post.slug', 1000, slugCheck);
});
