#-*-ruby-*-
#
# Copyright (C) 2006 John M. Gabriele <jmg3000@gmail.com>
#
# This program is distributed under the terms of the MIT license.
# See the included MIT-LICENSE file for the terms of this license.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
# OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require 'rubygems'

require 'rake'
require 'rake/extensiontask'
require 'rake/clean'
require 'rubygems/package_task'
require 'rake/testtask'
require 'hoe'
load 'Rakefile.cross'

# Generate html docs from the markdown source and upload to the site.
# All doc files that are destined for the website have filenames that
# end in .txt.

WEBSITE_MKDN = FileList['./doc/*.txt'] << 'README.txt'
NICE_HTML_DOCS = WEBSITE_MKDN.ext('html')

# defines columns in the HTML extension list
GLEXT_VERSIONS = ["svn","0.60","0.50"]

CLEAN.include("ext/gl*/Rakefile", "ext/*/mkrf.log", "ext/*/*.so",
              "ext/**/*.bundle", "lib/*.so", "lib/*.bundle", "ext/*/*.o{,bj}",
              "ext/*/*.lib", "ext/*/*.exp", "ext/*/*.pdb",
              "pkg")
CLOBBER.include("*.plain", "doc/*.plain", "doc/*.snip", "*.html",
                "doc/*.html", "website/*.html", "website/images/*")
# Make sure these files aren't deleted in a clobber op
CLOBBER.exclude("website/images/tab_bottom.gif")
CLOBBER.exclude("website/images/*.jpg")

desc 'Show contents of some variables related to website doc generation.'
task :explain_website do
    puts "WEBSITE_MKDN:"
    WEBSITE_MKDN.each do |doc|
        puts "\t#{doc}"
    end
    puts "NICE_HTML_DOCS:"
    NICE_HTML_DOCS.each do |doc|
        puts "\t#{doc}"
    end
end

desc 'Generate supported extension list.'
task :gen_glext_list do
	sh "./utils/extlistgen.rb doc/extensions.txt.in doc/extensions.txt " + GLEXT_VERSIONS.join(" ")
end

desc 'Generate website html.'
task :gen_website => [:gen_glext_list] + NICE_HTML_DOCS do
    # Now that the website docs have been generated, copy them to ./website.
    puts
    sh "cp README.html website/index.html"
    sh "cp doc/*.html website"
end

# You'll see some intermediate .plain files get generated. These are html,
# but don't yet have their code snippets syntax highlighted.
rule '.html' => '.plain' do |t|
    puts "Turning #{t.source} into #{t.name} ..."
    sh "./utils/post-mkdn2html.rb #{t.source} #{t.name}"
end

# Process the markdown docs into plain html.
rule '.plain' => '.txt' do |t|
    puts
    puts "Turning #{t.source} into #{t.name} ..."
    sh "./utils/mkdn2html.rb #{t.source} #{t.name}"
end

desc 'Upload the newly-built site to RubyForge.'
task :upload_website => [:gen_website] do
    sh "scp website/*.html hoanga@rubyforge.org:/var/www/gforge-projects/ruby-opengl"
    sh "scp website/images/* hoanga@rubyforge.org:/var/www/gforge-projects/ruby-opengl/images/"
end

desc 'Upload entire site, including stylesheet and the images directory.'
task :upload_entire_website => [:gen_website] do
    sh "scp website/*.html hoanga@rubyforge.org:/var/www/gforge-projects/ruby-opengl"
    sh "scp website/*.css hoanga@rubyforge.org:/var/www/gforge-projects/ruby-opengl"
    sh "scp -r website/images hoanga@rubyforge.org:/var/www/gforge-projects/ruby-opengl"
end




############# gems #############


hoe = Hoe.spec "opengl" do
  self.author = [ "Alain Hoang", "Jan Dvorak", "Minh Thu Vo", "James Adam" ]
  self.email = "ruby-opengl-devel@rubyforge.org"
  self.url = "http://ruby-opengl.rubyforge.org"
  self.rubyforge_name = 'ruby-opengl'
  self.version = IO.read("ext/gl/gl.c")[/VERSION += +([\"\'])([\d][\w\.]+)\1/] && $2
  self.local_rdoc_dir = 'rdoc'
  self.readme_file = 'README.md'
  self.extra_rdoc_files << self.readme_file

  spec_extras[:extensions] = ['ext/gl/extconf.rb', 'ext/glu/extconf.rb', 'ext/glut/extconf.rb']
  extra_dev_deps << ['rake-compiler', '>= 0.8']
end


ext_block = proc do |ext|
  ext.cross_compile = true
  ext.cross_platform = ['i386-mingw32']
  ext.cross_config_options += [
    "--with-installed-dir=#{STATIC_INSTALLDIR}",
  ]
end

Rake::ExtensionTask.new 'gl', hoe.spec, &ext_block
Rake::ExtensionTask.new 'glu', hoe.spec, &ext_block
Rake::ExtensionTask.new 'glut', hoe.spec, &ext_block
