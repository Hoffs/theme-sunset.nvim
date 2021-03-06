local SunCalc = {}

SunCalc.RAD = math.pi / 180
SunCalc.DAY_SEC = 60 * 60 * 24
SunCalc.J1970 = 2440588
SunCalc.J2000 = 2451545
SunCalc.E = SunCalc.RAD * 23.4397

function SunCalc:new (o)
	o = o or {}
	o.latitude = o.latitude or 48.85
	o.longitude = o.longitude or 10.5

	setmetatable(o, self)
	self.__index = self

	return o
end


function SunCalc:to_julian(unix_time)
	return unix_time / self.DAY_SEC - 0.5 + self.J1970
end

function SunCalc:from_julian(j)
	return (j + 0.5 - self.J1970) * self.DAY_SEC
end

function SunCalc:to_days(unix_time)
	return self:to_julian(unix_time) - self.J2000
end


-- General calculations for position

function SunCalc:right_ascension (l, b)
	return math.atan2(math.sin(l) * math.cos(self.E) - math.tan(b) * math.sin(self.E), math.cos(l))
end

function SunCalc:declination (l, b)
	return math.asin(math.sin(b) * math.cos(self.E) + math.cos(b) * math.sin(self.E) * math.sin(l))
end

function SunCalc:azimuth (h, phi, dec)
	return math.atan2(math.sin(h), math.cos(h) * math.sin(phi) - math.tan(dec) * math.cos(phi))
end

function SunCalc:altitude (h, phi, dec)
	return math.asin(math.sin(phi) * math.sin(dec) + math.cos(phi) * math.cos(dec) * math.cos(h))
end

function SunCalc:sidereal_time (d, lw)
	return self.RAD * (280.16 + 360.9856235 * d) - lw
end

function SunCalc:solar_mean_anomaly (d)
	return self.RAD * (357.5291 + 0.98560028 * d)
end

function SunCalc:ecliptic_longitude (m)
	local c = self.RAD * (1.9148 * math.sin(m) + 0.02 * math.sin(2*m) + 0.0003 * math.sin(3*m))
	local p = self.RAD * 102.9372
	return m + c + p + math.pi
end

function SunCalc:sun_coords (d)
	local sM = self:solar_mean_anomaly(d)
	local eL = self:ecliptic_longitude(sM)
	local dec = self:declination(eL,0)
	local ra = self:right_ascension(eL,0)
	return { dec=dec, ra=ra }
end

function SunCalc:get_sun_pos ()
	local lw = self.RAD * -self.longitude
	local phi = self.RAD * self.latitude
	local d = self:to_days(os.time())
	local c = self:sun_coords(d)
	local h = self:sidereal_time(d, lw) - c.ra
	local az = self:azimuth(h, phi, c.dec)
	local al = self:altitude(h, phi, c.dec)
	return (az / (math.pi * 2)) * 360 + 180, (al / (math.pi * 2)) * 360
end

return SunCalc
