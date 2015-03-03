if Rails.env == "test"
  Rails.application.config.datasources = {
    gupea: {  	
      apikey: ''  
    },
    scopus: {
      apikey: '1122334455'
    },
    crossref: {
      apikey: 'foo:foobar'
    },
    pubmed: {
      apikey: ''
    }
  }
end

