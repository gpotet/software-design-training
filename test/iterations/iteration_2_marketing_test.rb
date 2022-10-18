require "test_helper_training"

class Iteration4Test < TestHelperTraining
  test 'it sends a newsletter with the existing products' do
    skip 'unskip at iteration 2: Marketing'
    book = create_book(title: 'NoSQL For Dummies', isbn: '2100825208', purchase_price: 42, is_hot: false, created_at: Time.parse('2022-05-05 09:18'))
    create_ratings(book, [1,2,2,1]) # Average = 1.5
    create_book(title: 'Refactoring: Improving the Design of Existing Code', isbn: '9780134757599', purchase_price: 42, is_hot: false, created_at: Time.parse('2021-04-05'))

    image = create_image(title: 'XKCD: Good code', width: 800, height: 600, source: 'unknown', format: 'jpg', created_at: Time.parse('2022-05-19 19:32'))
    create_ratings(image, [5,5,4,4]) # Average = 4.5

    video = create_video(title: 'Living Documentation : you will like documentation', duration: 120, quality: 'HD', created_at: Time.parse('2022-05-23 13:01'))
    create_ratings(video, [5,4,4,1]) # Average = 3.5
    create_video(title: 'What is DDD - Eric Evans - DDD Europe', duration: 120, quality: 'HD', created_at: Time.parse('2022-05-31 09:18'))

    expected_mail_content = <<~MAIL
    Books
    - NoSQL For Dummies (1.5/5)
      - Price: 52.50
      - ISBN: 2100825208
    Images
    - XKCD: Good code (4.5/5)
      - Price: 7.00
      - Resolution: 800x600
    Videos
    - Living Documentation : you will like documentation (3.5/5)
      - Price: 15.00
      - Duration: 120 seconds
    MAIL

    mail_sender = mock
    mail_sender.expects(:send_newsletter).with(expected_mail_content)
    NewsletterJob.perform_now(from: '2022-05-01', to: '2022-05-30', mail_sender: mail_sender)
  end

  def create_ratings(product, ratings)
    ratings.each {|rating| Rating.create!(item: product, rating: rating)}
  end
end
