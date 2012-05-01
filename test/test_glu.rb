#
# Copyright (C) 2007 Jan Dvorak <jan.dvorak@kraxnet.cz>
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
#

require 'test/unit'
require 'glu'
include Glu

class Test_GLU < Test::Unit::TestCase
	def setup
		common_setup()
	end

	def teardown
		common_teardown()
	end

	def test_gluortho
		res = [ [2.0/$window_size, 0, 0, 0],
					  [0, 2.0/$window_size, 0, 0],
					  [0, 0, -1, 0],
						[-1,-1,0,1] ]

		glMatrixMode(GL_PROJECTION)
		glLoadIdentity()
		gluOrtho2D(0,$window_size,0,$window_size)
		assert_equal(glGetDoublev(GL_PROJECTION_MATRIX),res)
	end

	def test_glugetstring
		ver = gluGetString(GLU_VERSION)
		assert(ver.to_f > 1.1)
	end

	def test_gluerrorstring
		error = gluErrorString(GL_INVALID_VALUE)
		assert(error.class == String)
		assert(error.length > 2)
	end

	def test_glubuild2dmipmaps
		textures = glGenTextures(1)
		glBindTexture(GL_TEXTURE_2D,textures[0])

		image = ([0,0,0,1,1,1] * 8).pack("f*") # 16 RGB pixels

		gluBuild2DMipmaps(GL_TEXTURE_2D,GL_RGB8,4,4,GL_RGB,GL_FLOAT,image)
		im = glGetTexImage(GL_TEXTURE_2D,0,GL_RGB,GL_FLOAT)
		assert_equal(im,image)
		assert_equal(im.unpack("f*").size,4*4*3)
		im = glGetTexImage(GL_TEXTURE_2D,1,GL_RGB,GL_FLOAT)
		assert_equal(im.unpack("f*").size,2*2*3)
		im = glGetTexImage(GL_TEXTURE_2D,2,GL_RGB,GL_FLOAT)
		assert_equal(im.unpack("f*").size,1*1*3)

		glDeleteTextures(textures)
	end

	def test_glubuild1dmipmaps
		textures = glGenTextures(1)
		glBindTexture(GL_TEXTURE_1D,textures[0])

		image = ([0,0,0,1,1,1] * 2).pack("f*") # 4 RGB pixels

		gluBuild1DMipmaps(GL_TEXTURE_1D,GL_RGB8,4,GL_RGB,GL_FLOAT,image)

		im = glGetTexImage(GL_TEXTURE_1D,0,GL_RGB,GL_FLOAT)
		assert_equal(im,image)
		assert_equal(im.unpack("f*").size,4*3)
		im = glGetTexImage(GL_TEXTURE_1D,1,GL_RGB,GL_FLOAT)
		assert_equal(im.unpack("f*").size,2*3)
		im = glGetTexImage(GL_TEXTURE_1D,2,GL_RGB,GL_FLOAT)
		assert_equal(im.unpack("f*").size,1*3)

		glDeleteTextures(textures)
	end
	
	def test_glulookat
		m = [[0,0,1,0], [0,1,0,0], [-1,0,0,0], [0,0,-1, 1]]
		gluLookAt(1,0,0, 0,0,0, 0,1,0)
		assert_equal(glGetDoublev(GL_PROJECTION_MATRIX),m)
	end

	def test_gluproject
		pos = gluProject(1,1,1)
		assert_equal(pos,[$window_size,$window_size,1])

		mp = glGetDoublev(GL_PROJECTION_MATRIX)
		mm = Matrix.rows(glGetDoublev(GL_MODELVIEW_MATRIX))
		view = glGetDoublev(GL_VIEWPORT)
		pos = gluProject(1,1,1,mp,mm,view)
		assert_equal(pos,[$window_size,$window_size,1])

		assert_raise ArgumentError do pos = gluProject(1,1,1,mp,[1,2,3,4],view) end
	end

	def test_gluunproject
		pos = gluUnProject($window_size,$window_size,1)
		assert_equal(pos,[1,1,1])
		
		mp = glGetDoublev(GL_PROJECTION_MATRIX)
		mm = Matrix.rows(glGetDoublev(GL_MODELVIEW_MATRIX))
		view = glGetDoublev(GL_VIEWPORT)
		pos = gluUnProject($window_size,$window_size,1,mp,mm,view)
		assert_equal(pos,[1,1,1])
		assert_raise ArgumentError do	pos = gluUnProject($window_size,$window_size,1,mp,[1,2,3,4],view) end
	end

	def test_glupickmatrix
		t = $window_size / 5.0
		m = [[t, 0.0, 0.0, 0.0], [0.0, t, 0.0, 0.0], [0.0, 0.0, 1.0, 0.0], [t,t, 0.0, 1.0]]
		glMatrixMode(GL_PROJECTION)
		glLoadIdentity()
		gluPickMatrix(0,0)
		assert(approx_equal(glGetDoublev(GL_PROJECTION_MATRIX).flatten,m.flatten))
		glLoadIdentity()
		gluPickMatrix(0,0,5,5)
		assert(approx_equal(glGetDoublev(GL_PROJECTION_MATRIX).flatten,m.flatten))
		glLoadIdentity()
		gluPickMatrix(0,0,5,5,glGetDoublev(GL_VIEWPORT))
		assert(approx_equal(glGetDoublev(GL_PROJECTION_MATRIX).flatten,m.flatten))
	end

	def test_gluperspective
		m = [[1,0,0,0], [0,1,0,0], [0,0,-3,-1], [0,0,-4,0]]
		gluPerspective(90,1,1,2)
		assert_equal(glGetDoublev(GL_PROJECTION_MATRIX),m)
	end

	def test_gluscaleimage
		image = ([0,0,0,1,1,1] * 8).pack("f*") # 16 RGB pixels
		scaled = gluScaleImage(GL_RGB,4,4,GL_FLOAT,image, 2,2,GL_FLOAT)
		assert_equal(scaled.unpack("f*").length,2*2*3)
	end

	def test_gluquadrics
		ecount = 0
		error_func = lambda do |error|
			ecount+=1
		end
	
		q = gluNewQuadric()
		gluQuadricDrawStyle(q,GL_LINE)
		gluQuadricNormals(q,GL_SMOOTH)
		gluQuadricOrientation(q,GLU_OUTSIDE)
		gluQuadricTexture(q,GL_FALSE)
		gluQuadricCallback(q,GLU_ERROR,error_func)
	
		buf = glFeedbackBuffer(1024,GL_3D)
		glRenderMode(GL_FEEDBACK)
		gluSphere(q,1.0,4,3)
		count = glRenderMode(GL_RENDER)
		assert(count % 11 == 0)
	
		glRenderMode(GL_FEEDBACK)
		gluCylinder(q,1.0,1.0,1.0,4,3)
		count = glRenderMode(GL_RENDER)
		assert(count % 11 == 0)
	
		glRenderMode(GL_FEEDBACK)
		gluDisk(q,1.0,2.0,4,3)
		count = glRenderMode(GL_RENDER)
		assert(count % 11 == 0)
	
		glRenderMode(GL_FEEDBACK)
		gluPartialDisk(q,1.0,2.0,4,3,0,360)
		count = glRenderMode(GL_RENDER)
		assert(count % 11 == 0)
	
		gluSphere(q,0.0,0,0)
		assert_equal(ecount,1)
		gluDeleteQuadric(q)
	end
	
	def test_glunurbs
		ecount = 0

	  glViewport(0, 0, $window_size, $window_size)
		glMatrixMode(GL_PROJECTION)
    glOrtho(0, $window_size, 0, $window_size, -1, 1)

		n_error = lambda do |error|
			ecount += 1
		end
	
		m = [[1,0,0,0],[0,1,0,0],[0,0,1,0],[0,0,0,1]]
		m2 = Matrix.rows(m)
		
		n = gluNewNurbsRenderer()
		gluNurbsCallback(n,GLU_ERROR,n_error)
		gluNurbsProperty(n,GLU_SAMPLING_TOLERANCE,40)
		assert_equal(gluGetNurbsProperty(n,GLU_SAMPLING_TOLERANCE),40)
		
		gluLoadSamplingMatrices(n,m,m2,glGetIntegerv(GL_VIEWPORT))
		assert_raise ArgumentError do gluLoadSamplingMatrices(n,m,[1,2,3,4],glGetIntegerv(GL_VIEWPORT)) end

		knots = [0,0,0,0,1,1,1,1]
		ctlpoints_curve = [[50,50,0],[400,50,0],[400,400,0],[50,400,0]]
		
		# generate surface control points
		ctlpoints =  Array.new(4).collect { Array.new(4).collect { Array.new(3, nil) } } # 4*4*3 array
		0.upto(3)	do |u|
			0.upto(3) do |v|
				ctlpoints[u][v][0]=2.0*(u-1.5)
				ctlpoints[u][v][1]=2.0*(v-1.5)
			
				if ((u==1 || u==2) && (v==1 || v==2))
						ctlpoints[u][v][2]=6.0
				else
						ctlpoints[u][v][2]=0.0
				end
			end
		end
		
		buf = glFeedbackBuffer(1024*1024*8,GL_3D) # large enough buffer for tesselated surface
		glRenderMode(GL_FEEDBACK)
		gluBeginCurve(n)
		gluNurbsCurve(n,knots,ctlpoints_curve,4,GL_MAP1_VERTEX_3)
		gluEndCurve(n)

		gluBeginSurface(n)
		gluNurbsSurface(n,knots,knots,ctlpoints,4,4,GL_MAP2_VERTEX_3)
		gluEndSurface(n)
		
		gluBeginTrim(n)
		gluPwlCurve(n,[[0,0],[1,0],[1,1],[0,1],[0,0]],GLU_MAP1_TRIM_2)
		gluEndTrim(n)
		count = glRenderMode(GL_RENDER)
		assert(count>1)
		
		gluDeleteNurbsRenderer(n)
		assert(ecount>=1)
	end
	
	def test_glutess
	  glViewport(0, 0, $window_size, $window_size)
		glMatrixMode(GL_PROJECTION)
    glOrtho(0, $window_size, 0, $window_size, -1, 1)
		vcount,bcount,ecount = 0,0,0

		cb_begin = lambda do |type|
			bcount += 1
		end
		cb_end = lambda do
			ecount += 1
		end
		cb_vertex = lambda do |data|
			vcount += 1
		end
		cb_error = lambda do |error|
			p gluErrorString(error)
		end
	
		t = gluNewTess()
		gluTessCallback(t,GLU_TESS_BEGIN,cb_begin)
		gluTessCallback(t,GLU_TESS_END,cb_end)
		gluTessCallback(t,GLU_TESS_ERROR,cb_error)
		gluTessCallback(t,GLU_TESS_VERTEX,cb_vertex)
		gluTessProperty(t,GLU_TESS_BOUNDARY_ONLY,GL_TRUE)
		assert_equal(gluGetTessProperty(t,GLU_TESS_BOUNDARY_ONLY),GL_TRUE)
		gluTessProperty(t,GLU_TESS_BOUNDARY_ONLY,GL_FALSE)
		assert_equal(gluGetTessProperty(t,GLU_TESS_BOUNDARY_ONLY),GL_FALSE)
	
		gluTessNormal(t, 0.0, 0.0, 0.0)
	
		rect = [[50.0, 50.0, 0.0],
			[200.0, 50.0, 0.0],
			[200.0, 200.0, 0.0],
			[50.0, 200.0, 0.0]]
		tri = [[75.0, 75.0, 0.0],
			[125.0, 175.0, 0.0],
			[175.0, 75.0, 0.0]]

		gluTessBeginPolygon(t, nil)
		gluTessBeginContour(t)
		gluTessVertex(t, rect[0], rect[0])
		gluTessVertex(t, rect[1], rect[1])
		gluTessVertex(t, rect[2], rect[2])
		gluTessVertex(t, rect[3], rect[3])
		gluTessEndContour(t)
		gluTessBeginContour(t)
		gluTessVertex(t, tri[0], tri[0])
		gluTessVertex(t, tri[1], tri[1])
		gluTessVertex(t, tri[2], tri[2])
		gluTessEndContour(t)
		gluTessEndPolygon(t)
	
		gluTessCallback(t,GLU_TESS_BEGIN,nil)
		gluTessCallback(t,GLU_TESS_END,nil)
		gluTessCallback(t,GLU_TESS_ERROR,nil)
		gluTessCallback(t,GLU_TESS_VERTEX,nil)
	
		gluDeleteTess(t)
	
		assert_equal(bcount,1)
		assert_equal(ecount,1)
		assert_equal(vcount,3*3)
	end
end
