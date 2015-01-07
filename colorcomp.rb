#!/usr/local/rbenv/shims/ruby

require 'digest/md5'

def max(a, b)
	(a > b) ? a : b
end

def min(a, b)
	(a < b) ? a : b
end

class ColorComp
	@string1 = ""
	@color1 = ""
	@color2 = ""
	@rgb1 = []
	@rgb2 = []
	def initialize(inStr = "", inColor = "000000")
		@string1 = inStr
		@color1 = (Digest::MD5.hexdigest(@string1))[0,6]
		@color2 = inColor
		@rgb1 = Array.new(3)
		@rgb2 = Array.new(3)
	end
	def setrgb()
		for i in 0..2 do
			@rgb1[i] = (@color1[i*2,2]).hex
			@rgb2[i] = (@color2[i*2,2]).hex
		end
	end
	def compcolor()
		self.setrgb()
		bright1 =  ((@rgb1[0] * 299) + (@rgb1[1] * 587) + (@rgb1[2] * 114))  / 1000
		bright2 =  ((@rgb2[0] * 299) + (@rgb2[1] * 587) + (@rgb2[2] * 114))  / 1000
		diffb = (bright1 - bright2).abs
		diffc = (max(@rgb1[0],@rgb2[0]) - min(@rgb1[0],@rgb2[0]))
		diffc += (max(@rgb1[1],@rgb2[1]) - min(@rgb1[1],@rgb2[1])) 
		diffc += (max(@rgb1[2],@rgb2[2]) - min(@rgb1[2],@rgb2[2]))
		if diffb >= 125 && diffc >= 500
			return true
		else
			return false
		end
	end
	def getcolor()
		count = 0
		while !self.compcolor do
			count += 1
			@color1 = (Digest::MD5.hexdigest(@string1 + count.to_s))[0,6]
		end
		return @color1
	end
end
