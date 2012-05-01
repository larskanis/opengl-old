
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

class Test_EXT_NV < Test::Unit::TestCase
	def setup
		common_setup()
	end

	def teardown
		common_teardown()
	end

	def test_gl_nv_vertex_program
		return if not supported?("GL_NV_vertex_program")
	
		assert_equal(glIsProgramNV(0),false)
		programs = glGenProgramsNV(2)
		assert_equal(programs.size,2)
		
		program = "!!VSP1.0\nEND"
	
	  glBindProgramNV(GL_VERTEX_PROGRAM_NV, programs[1])
		glLoadProgramNV(GL_VERTEX_STATE_PROGRAM_NV, programs[0], program)
		assert_equal(glGetProgramStringNV(programs[0], GL_PROGRAM_STRING_NV), program)
		assert_equal(glIsProgramNV(programs[0]),true)	
	
		assert_equal(glGetProgramivNV(programs[0],GL_PROGRAM_LENGTH_NV),program.size)

		glVertexAttribPointerNV(1,2,GL_FLOAT,0,[1,1].pack("f*"))
		assert_equal(glGetVertexAttribPointervNV(1),[1,1].pack("f*"))

		glExecuteProgramNV(GL_VERTEX_STATE_PROGRAM_NV,programs[0],[1,1,1,1])

		glProgramParameter4dNV(GL_VERTEX_PROGRAM_NV,1, 1,2,3,4)
		assert_equal(glGetProgramParameterdvNV(GL_VERTEX_PROGRAM_NV,1,GL_PROGRAM_PARAMETER_NV),[1,2,3,4])
		glProgramParameter4fNV(GL_VERTEX_PROGRAM_NV,1, 5,6,7,8)
		assert_equal(glGetProgramParameterfvNV(GL_VERTEX_PROGRAM_NV,1,GL_PROGRAM_PARAMETER_NV),[5,6,7,8])
		glProgramParameter4dvNV(GL_VERTEX_PROGRAM_NV,1, [1,2,3,4])
		assert_equal(glGetProgramParameterdvNV(GL_VERTEX_PROGRAM_NV,1,GL_PROGRAM_PARAMETER_NV),[1,2,3,4])
		glProgramParameter4fvNV(GL_VERTEX_PROGRAM_NV,1, [5,6,7,8])
		assert_equal(glGetProgramParameterfvNV(GL_VERTEX_PROGRAM_NV,1,GL_PROGRAM_PARAMETER_NV),[5,6,7,8])

		glProgramParameters4fvNV(GL_VERTEX_PROGRAM_NV,1, [1,2,3,4,5,6,7,8])
		assert_equal(glGetProgramParameterfvNV(GL_VERTEX_PROGRAM_NV,1,GL_PROGRAM_PARAMETER_NV),[1,2,3,4])
		assert_equal(glGetProgramParameterfvNV(GL_VERTEX_PROGRAM_NV,2,GL_PROGRAM_PARAMETER_NV),[5,6,7,8])

		glProgramParameters4dvNV(GL_VERTEX_PROGRAM_NV,1, [8,7,6,5,4,3,2,1])
		assert_equal(glGetProgramParameterdvNV(GL_VERTEX_PROGRAM_NV,1,GL_PROGRAM_PARAMETER_NV),[8,7,6,5])
		assert_equal(glGetProgramParameterdvNV(GL_VERTEX_PROGRAM_NV,2,GL_PROGRAM_PARAMETER_NV),[4,3,2,1])


		glVertexAttrib1dNV(1,1)
		assert_equal(glGetVertexAttribdvNV(1,GL_CURRENT_ATTRIB_NV)[0],1)
		glVertexAttrib1fNV(1,2)
		assert_equal(glGetVertexAttribfvNV(1,GL_CURRENT_ATTRIB_NV)[0],2)
		glVertexAttrib1sNV(1,3)
		assert_equal(glGetVertexAttribivNV(1,GL_CURRENT_ATTRIB_NV)[0],3)
		glVertexAttrib1dvNV(1,[1])
		assert_equal(glGetVertexAttribdvNV(1,GL_CURRENT_ATTRIB_NV)[0],1)
		glVertexAttrib1fvNV(1,[2])
		assert_equal(glGetVertexAttribfvNV(1,GL_CURRENT_ATTRIB_NV)[0],2)
		glVertexAttrib1svNV(1,[3])
		assert_equal(glGetVertexAttribivNV(1,GL_CURRENT_ATTRIB_NV)[0],3)
	
		glVertexAttrib2dNV(1,1,2)
		assert_equal(glGetVertexAttribdvNV(1,GL_CURRENT_ATTRIB_NV)[0,2],[1,2])
		glVertexAttrib2fNV(1,2,3)
		assert_equal(glGetVertexAttribfvNV(1,GL_CURRENT_ATTRIB_NV)[0,2],[2,3])
		glVertexAttrib2sNV(1,3,4)
		assert_equal(glGetVertexAttribivNV(1,GL_CURRENT_ATTRIB_NV)[0,2],[3,4])
		glVertexAttrib2dvNV(1,[1,2])
		assert_equal(glGetVertexAttribdvNV(1,GL_CURRENT_ATTRIB_NV)[0,2],[1,2])
		glVertexAttrib2fvNV(1,[2,3])
		assert_equal(glGetVertexAttribfvNV(1,GL_CURRENT_ATTRIB_NV)[0,2],[2,3])
		glVertexAttrib2svNV(1,[3,4])
		assert_equal(glGetVertexAttribivNV(1,GL_CURRENT_ATTRIB_NV)[0,2],[3,4])
	
		glVertexAttrib3dNV(1,1,2,3)
		assert_equal(glGetVertexAttribdvNV(1,GL_CURRENT_ATTRIB_NV)[0,3],[1,2,3])
		glVertexAttrib3fNV(1,2,3,4)
		assert_equal(glGetVertexAttribfvNV(1,GL_CURRENT_ATTRIB_NV)[0,3],[2,3,4])
		glVertexAttrib3sNV(1,3,4,5)
		assert_equal(glGetVertexAttribivNV(1,GL_CURRENT_ATTRIB_NV)[0,3],[3,4,5])
		glVertexAttrib3dvNV(1,[1,2,3])
		assert_equal(glGetVertexAttribdvNV(1,GL_CURRENT_ATTRIB_NV)[0,3],[1,2,3])
		glVertexAttrib3fvNV(1,[2,3,4])
		assert_equal(glGetVertexAttribfvNV(1,GL_CURRENT_ATTRIB_NV)[0,3],[2,3,4])
		glVertexAttrib3svNV(1,[3,4,5])
		assert_equal(glGetVertexAttribivNV(1,GL_CURRENT_ATTRIB_NV)[0,3],[3,4,5])
	
		glVertexAttrib4dNV(1,1,2,3,4)
		assert_equal(glGetVertexAttribdvNV(1,GL_CURRENT_ATTRIB_NV)[0,4],[1,2,3,4])
		glVertexAttrib4fNV(1,2,3,4,5)
		assert_equal(glGetVertexAttribfvNV(1,GL_CURRENT_ATTRIB_NV)[0,4],[2,3,4,5])
		glVertexAttrib4sNV(1,3,4,5,6)
		assert_equal(glGetVertexAttribivNV(1,GL_CURRENT_ATTRIB_NV)[0,4],[3,4,5,6])
		glVertexAttrib4dvNV(1,[1,2,3,4])
		assert_equal(glGetVertexAttribdvNV(1,GL_CURRENT_ATTRIB_NV)[0,4],[1,2,3,4])
		glVertexAttrib4fvNV(1,[2,3,4,5])
		assert_equal(glGetVertexAttribfvNV(1,GL_CURRENT_ATTRIB_NV)[0,4],[2,3,4,5])
		glVertexAttrib4svNV(1,[3,4,5,6])
		assert_equal(glGetVertexAttribivNV(1,GL_CURRENT_ATTRIB_NV)[0,4],[3,4,5,6])

		glVertexAttrib4ubNV(1,2**8-1,0,2**8-1,0)
		assert_equal(glGetVertexAttribdvNV(1,GL_CURRENT_ATTRIB_NV)[0,4],[1,0,1,0])
		glVertexAttrib4ubvNV(1,[0,2**8-1,0,2**8-1])
		assert_equal(glGetVertexAttribdvNV(1,GL_CURRENT_ATTRIB_NV)[0,4],[0,1,0,1])

		glVertexAttribs1dvNV(1,[1,2])
		assert_equal(glGetVertexAttribdvNV(1,GL_CURRENT_ATTRIB_NV)[0],1)
		assert_equal(glGetVertexAttribdvNV(2,GL_CURRENT_ATTRIB_NV)[0],2)
		glVertexAttribs1fvNV(1,[3,4])
		assert_equal(glGetVertexAttribdvNV(1,GL_CURRENT_ATTRIB_NV)[0],3)
		assert_equal(glGetVertexAttribdvNV(2,GL_CURRENT_ATTRIB_NV)[0],4)
		glVertexAttribs1svNV(1,[5,6])
		assert_equal(glGetVertexAttribdvNV(1,GL_CURRENT_ATTRIB_NV)[0],5)
		assert_equal(glGetVertexAttribdvNV(2,GL_CURRENT_ATTRIB_NV)[0],6)

		glVertexAttribs2dvNV(1,[1,2,3,4])
		assert_equal(glGetVertexAttribdvNV(1,GL_CURRENT_ATTRIB_NV)[0,2],[1,2])
		assert_equal(glGetVertexAttribdvNV(2,GL_CURRENT_ATTRIB_NV)[0,2],[3,4])
		glVertexAttribs2fvNV(1,[3,4,5,6])
		assert_equal(glGetVertexAttribdvNV(1,GL_CURRENT_ATTRIB_NV)[0,2],[3,4])
		assert_equal(glGetVertexAttribdvNV(2,GL_CURRENT_ATTRIB_NV)[0,2],[5,6])
		glVertexAttribs2svNV(1,[5,6,7,8])
		assert_equal(glGetVertexAttribdvNV(1,GL_CURRENT_ATTRIB_NV)[0,2],[5,6])
		assert_equal(glGetVertexAttribdvNV(2,GL_CURRENT_ATTRIB_NV)[0,2],[7,8])

		glVertexAttribs3dvNV(1,[1,2,3,4,5,6])
		assert_equal(glGetVertexAttribdvNV(1,GL_CURRENT_ATTRIB_NV)[0,3],[1,2,3])
		assert_equal(glGetVertexAttribdvNV(2,GL_CURRENT_ATTRIB_NV)[0,3],[4,5,6])
		glVertexAttribs3fvNV(1,[3,4,5,6,7,8])
		assert_equal(glGetVertexAttribdvNV(1,GL_CURRENT_ATTRIB_NV)[0,3],[3,4,5])
		assert_equal(glGetVertexAttribdvNV(2,GL_CURRENT_ATTRIB_NV)[0,3],[6,7,8])
		glVertexAttribs3svNV(1,[5,6,7,8,9,10])
		assert_equal(glGetVertexAttribdvNV(1,GL_CURRENT_ATTRIB_NV)[0,3],[5,6,7])
		assert_equal(glGetVertexAttribdvNV(2,GL_CURRENT_ATTRIB_NV)[0,3],[8,9,10])
	
		glVertexAttribs4dvNV(1,[1,2,3,4,5,6,7,8])
		assert_equal(glGetVertexAttribdvNV(1,GL_CURRENT_ATTRIB_NV)[0,4],[1,2,3,4])
		assert_equal(glGetVertexAttribdvNV(2,GL_CURRENT_ATTRIB_NV)[0,4],[5,6,7,8])
		glVertexAttribs4fvNV(1,[3,4,5,6,7,8,9,10])
		assert_equal(glGetVertexAttribdvNV(1,GL_CURRENT_ATTRIB_NV)[0,4],[3,4,5,6])
		assert_equal(glGetVertexAttribdvNV(2,GL_CURRENT_ATTRIB_NV)[0,4],[7,8,9,10])
		glVertexAttribs4svNV(1,[5,6,7,8,9,10,11,12])
		assert_equal(glGetVertexAttribdvNV(1,GL_CURRENT_ATTRIB_NV)[0,4],[5,6,7,8])
		assert_equal(glGetVertexAttribdvNV(2,GL_CURRENT_ATTRIB_NV)[0,4],[9,10,11,12])
		glVertexAttribs4ubvNV(1,[2**8-1,0,2**8-1,0,2**8-1,0,2**8-1,0])
		assert_equal(glGetVertexAttribdvNV(1,GL_CURRENT_ATTRIB_NV)[0,4],[1,0,1,0])
		assert_equal(glGetVertexAttribdvNV(2,GL_CURRENT_ATTRIB_NV)[0,4],[1,0,1,0])

		glTrackMatrixNV(GL_VERTEX_PROGRAM_NV, 4, GL_MATRIX0_NV, GL_IDENTITY_NV);
		assert_equal(glGetTrackMatrixivNV(GL_VERTEX_PROGRAM_NV, 4, GL_TRACK_MATRIX_NV),GL_MATRIX0_NV)

		glRequestResidentProgramsNV(programs[0])
		res = glAreProgramsResidentNV(programs[0])
		assert_equal(res.size,1)
	
		glDeleteProgramsNV(programs)
	end

	def test_gl_nv_fragment_program
		return if not supported?("GL_NV_fragment_program")
		programs = glGenProgramsNV(1)
		program = "!!FP1.0\nDECLARE test = {0,0,0,0};\nEND"
	  glBindProgramNV(GL_FRAGMENT_PROGRAM_NV, programs[0])
		glLoadProgramNV(GL_FRAGMENT_PROGRAM_NV, programs[0], program)
		
		glProgramNamedParameter4fNV(programs[0],"test",1,2,3,4)
		assert_equal(glGetProgramNamedParameterfvNV(programs[0],"test"),[1,2,3,4])
		glProgramNamedParameter4dNV(programs[0],"test",5,6,7,8)
		assert_equal(glGetProgramNamedParameterdvNV(programs[0],"test"),[5,6,7,8])
		glProgramNamedParameter4fvNV(programs[0],"test",[1,2,3,4])
		assert_equal(glGetProgramNamedParameterfvNV(programs[0],"test"),[1,2,3,4])
		glProgramNamedParameter4dvNV(programs[0],"test",[5,6,7,8])
		assert_equal(glGetProgramNamedParameterdvNV(programs[0],"test"),[5,6,7,8])

		glDeleteProgramsNV(programs)
	end

	def test_gl_nv_framebuffer_multisample_coverage
		return if not supported?("GL_NV_framebuffer_multisample_coverage")
		rb = glGenRenderbuffersEXT(1)[0]

		glBindRenderbufferEXT(GL_RENDERBUFFER_EXT,rb)
		glRenderbufferStorageMultisampleCoverageNV(GL_RENDERBUFFER_EXT,4,4, GL_RGBA,2,2)
		samples = glGetRenderbufferParameterivEXT(GL_RENDERBUFFER_EXT,GL_RENDERBUFFER_COVERAGE_SAMPLES_NV)
		assert_equal(samples,4)
		samples = glGetRenderbufferParameterivEXT(GL_RENDERBUFFER_EXT,GL_RENDERBUFFER_COLOR_SAMPLES_NV)
		assert_equal(samples,4)

		glDeleteRenderbuffersEXT(rb)
	end

	def test_gl_nv_fence
		return if not supported?("GL_NV_fence")
			fences = glGenFencesNV(2)
			assert_equal(fences.size,2)
			
			glSetFenceNV(fences[0],GL_ALL_COMPLETED_NV)
			assert_equal(glGetFenceivNV(fences[0],GL_FENCE_CONDITION_NV),GL_ALL_COMPLETED_NV)
			assert_equal(glIsFenceNV(fences[0]),true)

			glFinishFenceNV(fences[0])
			assert_equal(glTestFenceNV(fences[0]),true)

			glDeleteFencesNV(fences)
	end

	def test_gl_nv_depth_buffer_float
		return if not supported?("GL_NV_depth_buffer_float")
		glDepthRangedNV(0.1,0.2)
		assert(approx_equal(glGetFloatv(GL_DEPTH_RANGE),[0.1,0.2]))
		glDepthBoundsdNV(0.1,0.2)
		assert(approx_equal(glGetFloatv(GL_DEPTH_BOUNDS_EXT),[0.1,0.2]))
		glClearDepthdNV(0.3)
		assert(approx_equal([glGetDoublev(GL_DEPTH_CLEAR_VALUE)],[0.3]))
	end

	def test_gl_nv_occlusion_query
		return if not supported?("GL_NV_occlusion_query")

		queries = glGenOcclusionQueriesNV(2)
		assert_equal(queries.size,2)

		glBeginOcclusionQueryNV(queries[0])
		assert_equal(glIsOcclusionQueryNV(queries[0]),true)

		glEndOcclusionQueryNV()
		r = glGetOcclusionQueryivNV(queries[0],GL_PIXEL_COUNT_AVAILABLE_NV)
		assert(r==GL_TRUE || r==GL_FALSE)
		assert(glGetOcclusionQueryuivNV(queries[0],GL_PIXEL_COUNT_NV)>=0)

		glDeleteOcclusionQueriesNV(queries)
		assert_equal(glIsOcclusionQueryNV(queries[1]),false)
	end

	def test_gl_nv_gpu_program4
		return if not supported?(["GL_NV_gpu_program4","GL_ARB_vertex_program"])

		programs = glGenProgramsARB(1)
		program = "!!ARBvp1.0\nTEMP vv;\nEND"
	
	  glBindProgramARB(GL_VERTEX_PROGRAM_ARB, programs[0])
		glProgramStringARB(GL_VERTEX_PROGRAM_ARB, GL_PROGRAM_FORMAT_ASCII_ARB, program)
		
		glProgramLocalParameterI4iNV(GL_VERTEX_PROGRAM_ARB,1, 1,2,3,4)
		assert_equal(glGetProgramLocalParameterIivNV(GL_VERTEX_PROGRAM_ARB,1),[1,2,3,4])
		glProgramLocalParameterI4uiNV(GL_VERTEX_PROGRAM_ARB,1, 5,6,7,8)
		assert_equal(glGetProgramLocalParameterIuivNV(GL_VERTEX_PROGRAM_ARB,1),[5,6,7,8])
		glProgramLocalParameterI4ivNV(GL_VERTEX_PROGRAM_ARB,1, [1,2,3,4])
		assert_equal(glGetProgramLocalParameterIivNV(GL_VERTEX_PROGRAM_ARB,1),[1,2,3,4])
		glProgramLocalParameterI4uivNV(GL_VERTEX_PROGRAM_ARB,1, [5,6,7,8])
		assert_equal(glGetProgramLocalParameterIuivNV(GL_VERTEX_PROGRAM_ARB,1),[5,6,7,8])
		glProgramLocalParametersI4ivNV(GL_VERTEX_PROGRAM_ARB,1, [1,2,3,4])
		assert_equal(glGetProgramLocalParameterIivNV(GL_VERTEX_PROGRAM_ARB,1),[1,2,3,4])
		glProgramLocalParametersI4uivNV(GL_VERTEX_PROGRAM_ARB,1, [5,6,7,8])
		assert_equal(glGetProgramLocalParameterIuivNV(GL_VERTEX_PROGRAM_ARB,1),[5,6,7,8])

		glProgramEnvParameterI4iNV(GL_VERTEX_PROGRAM_ARB,1, 1,2,3,4)
		assert_equal(glGetProgramEnvParameterIivNV(GL_VERTEX_PROGRAM_ARB,1),[1,2,3,4])
		glProgramEnvParameterI4uiNV(GL_VERTEX_PROGRAM_ARB,1, 5,6,7,8)
		assert_equal(glGetProgramEnvParameterIuivNV(GL_VERTEX_PROGRAM_ARB,1),[5,6,7,8])
		glProgramEnvParameterI4ivNV(GL_VERTEX_PROGRAM_ARB,1, [1,2,3,4])
		assert_equal(glGetProgramEnvParameterIivNV(GL_VERTEX_PROGRAM_ARB,1),[1,2,3,4])
		glProgramEnvParameterI4uivNV(GL_VERTEX_PROGRAM_ARB,1, [5,6,7,8])
		assert_equal(glGetProgramEnvParameterIuivNV(GL_VERTEX_PROGRAM_ARB,1),[5,6,7,8])
		glProgramEnvParametersI4ivNV(GL_VERTEX_PROGRAM_ARB,1, [1,2,3,4])
		assert_equal(glGetProgramEnvParameterIivNV(GL_VERTEX_PROGRAM_ARB,1),[1,2,3,4])
		glProgramEnvParametersI4uivNV(GL_VERTEX_PROGRAM_ARB,1, [5,6,7,8])
		assert_equal(glGetProgramEnvParameterIuivNV(GL_VERTEX_PROGRAM_ARB,1),[5,6,7,8])

		glDeleteProgramsARB(programs)
	end

	def test_gl_nv_gpu_program4
		return if not supported?(["GL_NV_gpu_program4","GL_EXT_framebuffer_object"])
		geometry_program = <<-EOP
!!NVgp4.0
PRIMITIVE_IN TRIANGLES;
PRIMITIVE_OUT TRIANGLE_STRIP;
VERTICES_OUT 1;
END
		EOP
			
    program_id = glGenProgramsARB(1)[0]
		glBindProgramARB(GL_GEOMETRY_PROGRAM_NV, program_id)
    glProgramStringARB(GL_GEOMETRY_PROGRAM_NV, GL_PROGRAM_FORMAT_ASCII_ARB, geometry_program);

		assert_equal(glGetProgramivARB(GL_GEOMETRY_PROGRAM_NV,GL_GEOMETRY_VERTICES_OUT_EXT),1)
    glProgramVertexLimitNV(GL_GEOMETRY_PROGRAM_NV, 2)
		assert_equal(glGetProgramivARB(GL_GEOMETRY_PROGRAM_NV,GL_GEOMETRY_VERTICES_OUT_EXT),2)

		#

		fbo = glGenFramebuffersEXT(1)[0]
		glBindFramebufferEXT(GL_FRAMEBUFFER_EXT,fbo)
	
		texture2d,texture3d,texture_cube = glGenTextures(3)
		glBindTexture(GL_TEXTURE_2D, texture2d)
		glBindTexture(GL_TEXTURE_3D, texture3d)
		glBindTexture(GL_TEXTURE_CUBE_MAP, texture_cube)

		glFramebufferTextureEXT(GL_FRAMEBUFFER_EXT,GL_COLOR_ATTACHMENT0_EXT,texture2d,0)
		assert_equal(glGetFramebufferAttachmentParameterivEXT(GL_FRAMEBUFFER_EXT,GL_COLOR_ATTACHMENT0_EXT, GL_FRAMEBUFFER_ATTACHMENT_OBJECT_NAME_EXT),texture2d)
		assert_equal(glGetFramebufferAttachmentParameterivEXT(GL_FRAMEBUFFER_EXT,GL_COLOR_ATTACHMENT0_EXT,GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL_EXT),0)
		glFramebufferTextureLayerEXT(GL_FRAMEBUFFER_EXT,GL_COLOR_ATTACHMENT0_EXT,texture3d,0,1)
		assert_equal(glGetFramebufferAttachmentParameterivEXT(GL_FRAMEBUFFER_EXT,GL_COLOR_ATTACHMENT0_EXT,GL_FRAMEBUFFER_ATTACHMENT_OBJECT_NAME_EXT),texture3d)
		assert_equal(glGetFramebufferAttachmentParameterivEXT(GL_FRAMEBUFFER_EXT,GL_COLOR_ATTACHMENT0_EXT,GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL_EXT),0)
		assert_equal(glGetFramebufferAttachmentParameterivEXT(GL_FRAMEBUFFER_EXT,GL_COLOR_ATTACHMENT0_EXT,GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER_EXT),1)

		glFramebufferTextureFaceEXT(GL_FRAMEBUFFER_EXT,GL_COLOR_ATTACHMENT0_EXT,texture_cube,0,GL_TEXTURE_CUBE_MAP_POSITIVE_X)
		assert_equal(glGetFramebufferAttachmentParameterivEXT(GL_FRAMEBUFFER_EXT,GL_COLOR_ATTACHMENT0_EXT,GL_FRAMEBUFFER_ATTACHMENT_OBJECT_NAME_EXT),texture_cube)
		assert_equal(glGetFramebufferAttachmentParameterivEXT(GL_FRAMEBUFFER_EXT,GL_COLOR_ATTACHMENT0_EXT,GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL_EXT),0)
		assert_equal(glGetFramebufferAttachmentParameterivEXT(GL_FRAMEBUFFER_EXT,GL_COLOR_ATTACHMENT0_EXT,GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE_EXT),GL_TEXTURE_CUBE_MAP_POSITIVE_X)

		glDeleteTextures([texture2d,texture3d])
		glDeleteFramebuffersEXT(fbo)
		glDeleteProgramsARB(program_id)
	end

	def test_gl_nv_primitive_restart
		return if not supported?("GL_NV_primitive_restart")
		glBegin(GL_TRIANGLES)
	  glPrimitiveRestartNV()
		glEnd
		glPrimitiveRestartIndexNV(2)
		assert_equal(glGetIntegerv(GL_PRIMITIVE_RESTART_INDEX_NV),2)
	end

	def test_gl_nv_point_sprite
		return if not supported?("GL_NV_point_sprite")
		glPointParameteriNV(GL_POINT_SPRITE_R_MODE_NV, GL_ZERO)
		assert_equal(glGetIntegerv(GL_POINT_SPRITE_R_MODE_NV),GL_ZERO)
		glPointParameteriNV(GL_POINT_SPRITE_R_MODE_NV, GL_S)
		assert_equal(glGetIntegerv(GL_POINT_SPRITE_R_MODE_NV),GL_S)

		glPointParameterivNV(GL_POINT_SPRITE_R_MODE_NV, [GL_ZERO])
		assert_equal(glGetIntegerv(GL_POINT_SPRITE_R_MODE_NV),GL_ZERO)
		glPointParameterivNV(GL_POINT_SPRITE_R_MODE_NV, [GL_S])
		assert_equal(glGetIntegerv(GL_POINT_SPRITE_R_MODE_NV),GL_S)
	end
end
