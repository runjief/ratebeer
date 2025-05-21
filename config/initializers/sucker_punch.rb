unless Rails.env.test?
  Rails.application.config.after_initialize do
    UpdateRatingCacheJob.perform_async
  end
end