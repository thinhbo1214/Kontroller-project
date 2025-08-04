// api
// async PostReview(gameId, rating, liked, reviewText) {
//     const payload = { gameId, rating, liked, reviewText, createdAt: new Date().toISOString() };
//     const res = await this.POST('', {
//         headers: { 'Content-Type': 'application/json' },
//         body: JSON.stringify(payload)
//     });
//     return res;
// }
// event
// case action.includes('submitReview'):
//     Handle.handleReviewSubmit(e);
//     break;

// handle
// handleReviewSubmit = async (e) => {
//     e.preventDefault();
//     const gameId = 'some-game-id'; // Replace with dynamic game ID
//     const rating = document.getElementById('rating').value;
//     const liked = document.getElementById('liked').checked;
//     const reviewText = document.getElementById('reviewText').value;

//     if (!rating || !reviewText) {
//         UI.showError('Rating and review are required!');
//         return;
//     }

//     try {
//         UI.showLoading(true);
//         const result = await API.review.PostReview(gameId, parseInt(rating), liked, reviewText);
//         if (result.ok) {
//             UI.showSuccess('Review submitted successfully!');
//             // Optionally clear fields or redirect
//             document.getElementById('rating').value = '';
//             document.getElementById('liked').checked = false;
//             document.getElementById('reviewText').value = '';
//         } else {
//             UI.showError(result.data.message || 'Failed to submit review');
//         }
//     } catch (error) {
//         UI.showError('An error occurred: ' + error.message);
//     } finally {
//         UI.showLoading(false);
//     }
// }