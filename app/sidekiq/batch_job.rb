class BatchJob
  include Sidekiq::Job
  include Sidekiq::Lock::Worker

  sidekiq_options({
    retry: 0,
    lock: {timeout: 5.minutes.to_i, name: self.class.to_s}
  })

  def perform
    if !lock.acquire!
      puts 'NOT ACQUIRED'
      return
    end
    begin
      puts 'ACQUIRED... sleeping'
      sleep 60
    ensure
      puts "RELEASING"
      lock.release!
    end
  end
end
