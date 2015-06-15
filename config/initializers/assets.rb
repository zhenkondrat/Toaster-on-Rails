Rails.application.config.assets.precompile += %w( pages/* ckeditor/own_config.js student.css user_footer.jpg )
Rails.application.config.assets.precompile += %w( ckeditor/own_config.js
                                                  ckeditor/config.js
                                                  ckeditor/lang/en.js
                                                  ckeditor/styles.js
                                                  ckeditor/init.js
                                                  ckeditor/contents.css
                                                  ckeditor/plugins/dragresize/plugin.js
                                                  ckeditor/filebrowser/javascripts/fileuploader.js
                                                  ckeditor/filebrowser/javascripts/rails.js
                                                  ckeditor/filebrowser/javascripts/application.js
                                                  ckeditor/filebrowser/images/*
)
