User.create!(name:  "Example User",
             email: "example@example.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin:     true,
             activated: true,
             activated_at: Time.zone.now)

15.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@example.org"
  password = "password"
  User.create!(name:  name,
              email: email,
              password:              password,
              password_confirmation: password,
              activated: true,
              activated_at: Time.zone.now)
end

League.create!(name: "LeagueOne",
                num_teams: 8,
                num_divisions: 1,
                season: 2017,
                pa_yd: 0.04,
                pa_td: 6,
                pa_int: -2,
                ru_yd: 0.1,
                ru_td: 6,
                re_yd: 0.1,
                rec: 0.5,
                re_td: 6,
                fum: -1,
                fuml: -1,
                tpc: 2)

Division.create!(name: "DivOne",
                league_id: 1)

Team.create!(name: "Example Team",
            logo: "logo1.jpg",
            is_commissioner: true,
            league_id: 1,
            user_id: 1)

Lineup.create!(qb_id: 1,
                rb1_id: 1,
                rb2_id: 2,
                wr1_id: 3,
                wr2_id: 4,
                week: 1,
                team_id: 1,
                division_id: 1)
