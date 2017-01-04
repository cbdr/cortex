angular.module('cortex.services.cortex', [
  'cortex.settings',
  'cortex.resources'
])

.factory('cortex', function($rootScope, $http, cortexResource, paginatedResource, settings) {
  var categories = cortexResource('/categories/:id', {id: '@id'}, {
    hierarchy: {
      method: 'GET',
      url:     settings.cortex_base_url + '/categories/:id/hierarchy',
      isArray: true
    }
  });

  var locales = paginatedResource('/localizations/:localization_id/locales/:locale_name', {locale_name: '@locale_name'}, {
    search: {method: 'GET', params: {}, isArray: true, paginated: true}
  });

  var localizations = paginatedResource('/localizations/:id', {id: '@id'}, {
    search: {method: 'GET', params: {}, isArray: true, paginated: true}
  });

  var posts = paginatedResource('/posts/:id', {id: '@id'}, {
    feed:    {method: 'GET', params: {id: 'feed'}, isArray: true, paginated: true},
    tags:    {method: 'GET', params: {id: 'tags'}, isArray: true},
    search:  {method: 'GET', params: { }, isArray: true, paginated: true},
    filters: {method: 'GET', params: {id: 'filters'} }
  });

  var media = paginatedResource('/media/:id', {id: '@id'}, {
    tags:   {method: 'GET', params: {id: 'tags'}, isArray: true},
    search: {method: 'GET', params: { }, isArray: true, paginated: true},
    bulkJob: {
      method: 'POST',
      url: settings.cortex_base_url + '/media/bulk_job'
    }
  });

  var users = paginatedResource('/users/:id', {id: '@id'}, {
    me:     {method: 'GET', params: {id: 'me'}},
    bulkJob: {
      method: 'POST',
      url: settings.cortex_base_url + '/users/bulk_job'
    }
  });

  var tenants = paginatedResource('/tenants/:id', {id: '@id'}, {
    hierarchicalIndex: {method: 'GET', params: {include_children: true}, isArray: true},
    users: {
      method: 'GET',
      url:     settings.cortex_base_url + '/tenants/:id/users',
      isArray: true,
      paginated: true
    }
  });

  var userAuthor = cortexResource('/users/:user_id/author', {user_id: '@user_id'});

  var occupations = cortexResource('/occupations/:id', {id: '@id', isArray: true}, {
    industries: {method: 'GET', params: {id: 'industries'}, isArray: true}
  });

  var applications = paginatedResource('/applications/:id', {id: '@id', isArray: true}, {
    search: {method: 'GET', params: {}, isArray: true, paginated: true}
  });

  var credentials = paginatedResource('/applications/:application_id/credentials/:credentials_id', {credential_ids: '@credentials_id'}, {
    search: {method: 'GET', params: {}, isArray: true, paginated: true}
  });

  var bulkJobs = paginatedResource('/bulk_jobs/:id', {id: '@id'}, {
    search:  {method: 'GET', params: { }, isArray: true, paginated: true}
  });

  var webpages = paginatedResource('/webpages/:id', {id: '@id'}, {
    search: {method: 'GET', params: { }, isArray: true, paginated: true},
    feed:    {method: 'GET', params: {id: 'feed'}, isArray: true, paginated: true}
  });

  return {
    categories:    categories,
    locales:       locales,
    localizations: localizations,
    posts:         posts,
    media:         media,
    tenants:       tenants,
    users:         users,
    userAuthor:    userAuthor,
    occupations:   occupations,
    applications:  applications,
    credentials:   credentials,
    bulk_jobs:     bulkJobs,
    webpages:      webpages
  };
});
