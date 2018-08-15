document.addEventListener('DOMContentLoaded', function() {
  const body = document.getElementsByTagName('body')[0];
  const fileUpload = document.getElementById('file-upload');
  const fileName = document.getElementById('filename');
  const fileSubmit = document.getElementById('file-submit');

  fileSubmit.style.display = 'none';

  fileUpload.addEventListener('change', function() {
    let filepath = this.value;
    let match = filepath.match(/([^\/\\]+)$/);
    let filename = match[1];
    fileName.innerHTML = filename;
    fileSubmit.removeAttribute('style');
  })

  const modal = document.getElementById('fullImage');
  const img = document.getElementsByClassName('uploadedThumbnail');
  const modalImg = document.getElementById('uploadedFull');
  const close = document.getElementsByClassName('closeImage')[0];

  for (let image of img) {
    image.addEventListener('click', function() {
      body.style.overflow = 'hidden';
      modal.style.display = 'block';
      let hiddenImg = document.getElementsByClassName('hiddenFullImage');
      for (hidden of hiddenImg) {
        if (hidden.className.split(' ')[0] == this.id){
          modalImg.src = hidden.src;
        }
      }

      close.addEventListener('click', function() {
        modal.style.display = 'none';
        body.removeAttribute('style');
      })

      document.addEventListener('keyup', function(e) {
        if (e.keyCode === 27) {
          modal.style.display = 'none';
          body.removeAttribute('style');
        }
      })
    })
  }

  const localOption = document.getElementById('local_upload_first');
  const webcamOption = document.getElementById('webcam');
  const fullWebcam = document.getElementById('fullWebcam');
  const video = document.getElementById('video');
  const closeWebcam = document.getElementsByClassName('closeWebcam')[0];

  if (localOption) {
    localOption.addEventListener('click', changeForm)
    function changeForm(e) {
      let hiddenForm = document.getElementById('hiddenForm');
      hiddenForm.id = 'uploadForm';
      e.target.removeEventListener(e.type, arguments.callee);
    }
  }

  webcamOption.addEventListener('click', function() {
    fullWebcam.style.display = 'block';
    body.style.overflow = 'hidden';

    if (navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
     navigator.mediaDevices.getUserMedia({ video: true }).then(function(stream) {
      video.srcObject = stream;

      closeWebcam.addEventListener('click', function() {
        stream.getTracks().forEach(track => track.stop());
        fullWebcam.style.display = 'none';
        body.removeAttribute('style');
      })

      document.addEventListener('keyup', function(e) {
        if (e.keyCode === 27) {
          stream.getTracks().forEach(track => track.stop());
          fullWebcam.style.display = 'none';
          body.removeAttribute('style');
        }
      })
    });
    }
  })

  function takeSnapshot() {
    let img = document.createElement('img');
    let width = video.offsetWidth;
    let height = video.offsetHeight;

    let canvas = document.createElement('canvas');
    canvas.width = width;
    canvas.height = height;

    let context = canvas.getContext('2d');
    context.drawImage(video, 0, 0, width, height);

    document.getElementById('hiddenURL').value = canvas.toDataURL('image/png');
    const snapshotForm = document.getElementById('snapshotForm');
    snapshotForm.submit();
  }

  const snapshot = document.getElementById('snapshot');
  snapshot.addEventListener('click', function() {
    takeSnapshot();
  })

})
