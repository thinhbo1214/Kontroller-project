import React, { useState } from 'react';
import { Star, TrendingUp, Calendar, Users, Search, Heart, MessageCircle, Share2, Play, Trophy, Clock, Filter } from 'lucide-react';

const HomePage = () => {
  const [selectedFilter, setSelectedFilter] = useState('trending');

  // Mock data cho games
  const featuredGames = [
    {
      id: 1,
      title: "Cyberpunk 2077",
      year: 2020,
      rating: 4.2,
      totalRatings: 15420,
      image: "https://images.unsplash.com/photo-1542751371-adc38448a05e?w=300&h=400&fit=crop",
      genre: ["RPG", "Action"],
      isNew: true
    },
    {
      id: 2,
      title: "The Witcher 3",
      year: 2015,
      rating: 4.8,
      totalRatings: 28930,
      image: "https://images.unsplash.com/photo-1493711662062-fa541adb3fc8?w=300&h=400&fit=crop",
      genre: ["RPG", "Fantasy"],
      isNew: false
    },
    {
      id: 3,
      title: "Elden Ring",
      year: 2022,
      rating: 4.6,
      totalRatings: 22100,
      image: "https://images.unsplash.com/photo-1538481199705-c710c4e965fc?w=300&h=400&fit=crop",
      genre: ["Action", "RPG"],
      isNew: true
    },
    {
      id: 4,
      title: "Red Dead Redemption 2",
      year: 2018,
      rating: 4.7,
      totalRatings: 31200,
      image: "https://images.unsplash.com/photo-1511512578047-dfb367046420?w=300&h=400&fit=crop",
      genre: ["Action", "Adventure"],
      isNew: false
    }
  ];

  const trendingGames = [
    {
      id: 5,
      title: "Baldur's Gate 3",
      year: 2023,
      rating: 4.9,
      totalRatings: 18500,
      image: "https://images.unsplash.com/photo-1509198397868-475647b2a1e5?w=200&h=300&fit=crop",
      genre: ["RPG", "Strategy"]
    },
    {
      id: 6,
      title: "Hogwarts Legacy",
      year: 2023,
      rating: 4.3,
      totalRatings: 12400,
      image: "https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=200&h=300&fit=crop",
      genre: ["Action", "RPG"]
    },
    {
      id: 7,
      title: "Spider-Man 2",
      year: 2023,
      rating: 4.5,
      totalRatings: 9800,
      image: "https://images.unsplash.com/photo-1635805737707-575885ab0820?w=200&h=300&fit=crop",
      genre: ["Action", "Adventure"]
    },
    {
      id: 8,
      title: "Starfield",
      year: 2023,
      rating: 3.8,
      totalRatings: 7600,
      image: "https://images.unsplash.com/photo-1446776877081-d282a0f896e2?w=200&h=300&fit=crop",
      genre: ["RPG", "Sci-Fi"]
    }
  ];

  const recentReviews = [
    {
      id: 1,
      user: "GameMaster92",
      avatar: "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=40&h=40&fit=crop&crop=face",
      game: "Cyberpunk 2077",
      rating: 4,
      review: "Sau nhiều lần cập nhật, game đã trở nên tuyệt vời hơn nhiều. Thế giới mở rất chi tiết và hấp dẫn.",
      date: "2 hours ago",
      likes: 12,
      comments: 3
    },
    {
      id: 2,
      user: "RPGFanatic",
      avatar: "https://images.unsplash.com/photo-1494790108755-2616b612b5bc?w=40&h=40&fit=crop&crop=face",
      game: "Baldur's Gate 3",
      rating: 5,
      review: "Masterpiece của thể loại RPG! Storyline phong phú, character development tuyệt vời.",
      date: "4 hours ago",
      likes: 28,
      comments: 7
    },
    {
      id: 3,
      user: "CasualGamer",
      avatar: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=40&h=40&fit=crop&crop=face",
      game: "Elden Ring",
      rating: 4,
      review: "Challenging nhưng rất rewarding. Graphics và world design đẹp tuyệt vời.",
      date: "1 day ago",
      likes: 15,
      comments: 2
    }
  ];

  const GameCard = ({ game, size = "large" }) => (
    <div className={`group relative ${size === "large" ? "w-full" : "w-48"} cursor-pointer`}>
      <div className="relative overflow-hidden rounded-lg bg-gray-800 shadow-lg transition-all duration-300 group-hover:shadow-2xl group-hover:scale-105">
        <img 
          src={game.image} 
          alt={game.title}
          className={`w-full object-cover ${size === "large" ? "h-80" : "h-64"}`}
        />
        <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-black/20 to-transparent" />
        
        {game.isNew && (
          <div className="absolute top-2 left-2 bg-green-500 text-white px-2 py-1 rounded-full text-xs font-semibold">
            NEW
          </div>
        )}
        
        <div className="absolute bottom-0 left-0 right-0 p-4 text-white">
          <h3 className="font-bold text-lg mb-1 group-hover:text-blue-400 transition-colors">
            {game.title}
          </h3>
          <p className="text-gray-300 text-sm mb-2">{game.year}</p>
          
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-2">
              <div className="flex items-center">
                <Star className="w-4 h-4 text-yellow-400 fill-current" />
                <span className="ml-1 text-sm font-semibold">{game.rating}</span>
              </div>
              <span className="text-gray-400 text-xs">({game.totalRatings.toLocaleString()})</span>
            </div>
            
            <div className="flex space-x-1">
              {game.genre.slice(0, 2).map((g, index) => (
                <span key={index} className="bg-blue-600/80 text-xs px-2 py-1 rounded-full">
                  {g}
                </span>
              ))}
            </div>
          </div>
        </div>
        
        <div className="absolute inset-0 bg-black/50 opacity-0 group-hover:opacity-100 transition-opacity duration-300 flex items-center justify-center">
          <Play className="w-12 h-12 text-white" />
        </div>
      </div>
    </div>
  );

  const ReviewCard = ({ review }) => (
    <div className="bg-gray-800 rounded-lg p-4 mb-4">
      <div className="flex items-start space-x-3">
        <img 
          src={review.avatar} 
          alt={review.user}
          className="w-10 h-10 rounded-full object-cover"
        />
        <div className="flex-1">
          <div className="flex items-center justify-between mb-2">
            <div>
              <h4 className="font-semibold text-white">{review.user}</h4>
              <p className="text-gray-400 text-sm">reviewed {review.game}</p>
            </div>
            <div className="flex items-center">
              {[...Array(5)].map((_, i) => (
                <Star 
                  key={i} 
                  className={`w-4 h-4 ${i < review.rating ? 'text-yellow-400 fill-current' : 'text-gray-600'}`} 
                />
              ))}
            </div>
          </div>
          
          <p className="text-gray-300 mb-3">{review.review}</p>
          
          <div className="flex items-center justify-between text-sm text-gray-400">
            <span>{review.date}</span>
            <div className="flex items-center space-x-4">
              <button className="flex items-center space-x-1 hover:text-red-400 transition-colors">
                <Heart className="w-4 h-4" />
                <span>{review.likes}</span>
              </button>
              <button className="flex items-center space-x-1 hover:text-blue-400 transition-colors">
                <MessageCircle className="w-4 h-4" />
                <span>{review.comments}</span>
              </button>
              <button className="hover:text-green-400 transition-colors">
                <Share2 className="w-4 h-4" />
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );

  return (
    <div className="min-h-screen bg-gray-900 text-white">
      {/* Hero Section */}
      <div className="relative bg-gradient-to-r from-purple-900 via-blue-900 to-indigo-900 py-20">
        <div className="absolute inset-0 bg-black/30" />
        <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center">
            <h1 className="text-5xl md:text-7xl font-bold mb-6 bg-gradient-to-r from-blue-400 to-purple-400 bg-clip-text text-transparent">
              GameRate
            </h1>
            <p className="text-xl md:text-2xl text-gray-300 mb-8 max-w-3xl mx-auto">
              Discover, rate, and review the best games. Join our community of gamers and share your gaming experiences.
            </p>
            
            <div className="max-w-2xl mx-auto relative">
              <Search className="absolute left-4 top-1/2 transform -translate-y-1/2 text-gray-400 w-5 h-5" />
              <input 
                type="text" 
                placeholder="Search for games, developers, or genres..."
                className="w-full pl-12 pr-4 py-4 rounded-full bg-gray-800/80 border border-gray-700 focus:border-blue-500 focus:outline-none text-white placeholder-gray-400"
              />
            </div>
          </div>
        </div>
      </div>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        {/* Stats Section */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-6 mb-12">
          <div className="bg-gray-800 rounded-lg p-6 text-center">
            <Trophy className="w-8 h-8 text-yellow-400 mx-auto mb-2" />
            <h3 className="text-2xl font-bold text-white">25,432</h3>
            <p className="text-gray-400">Games Rated</p>
          </div>
          <div className="bg-gray-800 rounded-lg p-6 text-center">
            <Users className="w-8 h-8 text-blue-400 mx-auto mb-2" />
            <h3 className="text-2xl font-bold text-white">12,891</h3>
            <p className="text-gray-400">Active Members</p>
          </div>
          <div className="bg-gray-800 rounded-lg p-6 text-center">
            <MessageCircle className="w-8 h-8 text-green-400 mx-auto mb-2" />
            <h3 className="text-2xl font-bold text-white">89,234</h3>
            <p className="text-gray-400">Reviews Written</p>
          </div>
          <div className="bg-gray-800 rounded-lg p-6 text-center">
            <Clock className="w-8 h-8 text-purple-400 mx-auto mb-2" />
            <h3 className="text-2xl font-bold text-white">2.1M</h3>
            <p className="text-gray-400">Hours Tracked</p>
          </div>
        </div>

        {/* Featured Games */}
        <section className="mb-12">
          <h2 className="text-3xl font-bold mb-6 flex items-center">
            <Star className="w-8 h-8 text-yellow-400 mr-3" />
            Featured Games
          </h2>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            {featuredGames.map(game => (
              <GameCard key={game.id} game={game} />
            ))}
          </div>
        </section>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
          {/* Trending Games */}
          <div className="lg:col-span-2">
            <div className="flex items-center justify-between mb-6">
              <h2 className="text-3xl font-bold flex items-center">
                <TrendingUp className="w-8 h-8 text-green-400 mr-3" />
                Trending Now
              </h2>
              <div className="flex space-x-2">
                <button 
                  onClick={() => setSelectedFilter('trending')}
                  className={`px-4 py-2 rounded-full text-sm transition-colors ${
                    selectedFilter === 'trending' 
                      ? 'bg-blue-600 text-white' 
                      : 'bg-gray-700 text-gray-300 hover:bg-gray-600'
                  }`}
                >
                  <TrendingUp className="w-4 h-4 inline mr-1" />
                  Trending
                </button>
                <button 
                  onClick={() => setSelectedFilter('new')}
                  className={`px-4 py-2 rounded-full text-sm transition-colors ${
                    selectedFilter === 'new' 
                      ? 'bg-blue-600 text-white' 
                      : 'bg-gray-700 text-gray-300 hover:bg-gray-600'
                  }`}
                >
                  <Calendar className="w-4 h-4 inline mr-1" />
                  New Releases
                </button>
                <button 
                  onClick={() => setSelectedFilter('top')}
                  className={`px-4 py-2 rounded-full text-sm transition-colors ${
                    selectedFilter === 'top' 
                      ? 'bg-blue-600 text-white' 
                      : 'bg-gray-700 text-gray-300 hover:bg-gray-600'
                  }`}
                >
                  <Star className="w-4 h-4 inline mr-1" />
                  Top Rated
                </button>
              </div>
            </div>
            
            <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
              {trendingGames.map(game => (
                <GameCard key={game.id} game={game} size="small" />
              ))}
            </div>
          </div>

          {/* Recent Reviews */}
          <div>
            <h2 className="text-2xl font-bold mb-6 flex items-center">
              <MessageCircle className="w-6 h-6 text-blue-400 mr-2" />
              Recent Reviews
            </h2>
            <div className="space-y-4">
              {recentReviews.map(review => (
                <ReviewCard key={review.id} review={review} />
              ))}
            </div>
            
            <button className="w-full mt-6 py-3 bg-gray-700 hover:bg-gray-600 rounded-lg transition-colors">
              View All Reviews
            </button>
          </div>
        </div>

        {/* Call to Action */}
        <div className="mt-16 bg-gradient-to-r from-purple-800 to-blue-800 rounded-2xl p-8 text-center">
          <h2 className="text-3xl font-bold mb-4">Join Our Gaming Community</h2>
          <p className="text-xl text-gray-300 mb-6">
            Rate games, write reviews, and discover your next favorite title
          </p>
          <button className="bg-white text-gray-900 px-8 py-3 rounded-full font-semibold hover:bg-gray-100 transition-colors">
            Sign Up Now
          </button>
        </div>
      </div>
    </div>
  );
};

export default HomePage;