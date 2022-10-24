require_relative "lib/products/version"

Gem::Specification.new do |spec|
  spec.name        = "products"
  spec.version     = Products::VERSION
  spec.authors     = ["My Media Store"]
  spec.summary     = "Products engine"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.0.3"
end
