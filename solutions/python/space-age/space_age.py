class SpaceAge:
    def __init__(self, seconds):
        self.seconds = seconds
        self.earth_year_seconds = 31557600

    def on_earth(self):
        return round(self.seconds / self.earth_year_seconds, 2)

    def on_mercury(self):
        mercury_year_seconds = 0.2408467 * self.earth_year_seconds
        return round(self.seconds / mercury_year_seconds, 2)

    def on_venus(self):
        venus_year_seconds = 0.61519726 * self.earth_year_seconds
        return round(self.seconds / venus_year_seconds, 2)

    def on_mars(self):
        mars_year_seconds = 1.8808158 * self.earth_year_seconds
        return round(self.seconds / mars_year_seconds, 2)

    def on_jupiter(self):
        jupiter_year_seconds = 11.862615 * self.earth_year_seconds
        return round(self.seconds / jupiter_year_seconds, 2)

    def on_saturn(self):
        saturn_year_seconds = 29.447498 * self.earth_year_seconds
        return round(self.seconds / saturn_year_seconds, 2)

    def on_uranus(self):
        uranus_year_seconds = 84.016846 * self.earth_year_seconds
        return round(self.seconds / uranus_year_seconds, 2)

    def on_neptune(self):
        neptune_year_seconds = 164.79132 * self.earth_year_seconds
        return round(self.seconds / neptune_year_seconds, 2)
