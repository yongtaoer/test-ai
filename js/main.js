// 处理联系表单提交
document.addEventListener('DOMContentLoaded', function () {
    const contactForm = document.getElementById('contactForm');
    if (contactForm) {
        contactForm.addEventListener('submit', function (e) {
            e.preventDefault();

            // 获取表单数据
            const formData = {
                name: document.getElementById('name').value,
                email: document.getElementById('email').value,
                message: document.getElementById('message').value
            };

            // 这里可以添加发送到服务器的逻辑
            alert('感谢您的留言！我们会尽快回复。');
            contactForm.reset();
        });
    }
});

// 首页 Banner 轮播功能
document.addEventListener('DOMContentLoaded', function () {
    const slider = document.querySelector('.hero-slider');
    if (!slider) return;

    const slides = Array.from(slider.querySelectorAll('.hero-slide'));
    const dotsContainer = document.querySelector('.slide-dots');
    const prevButton = document.querySelector('.prev-slide');
    const nextButton = document.querySelector('.next-slide');
    let currentSlide = 0;
    let autoSlideInterval;

    // 创建轮播点
    slides.forEach((_, index) => {
        const dot = document.createElement('div');
        dot.classList.add('dot');
        if (index === 0) dot.classList.add('active');
        dot.addEventListener('click', () => goToSlide(index));
        dotsContainer.appendChild(dot);
    });

    // 切换到指定幻灯片
    function goToSlide(index) {
        slides[currentSlide].classList.remove('active');
        dotsContainer.children[currentSlide].classList.remove('active');

        currentSlide = index;
        if (currentSlide >= slides.length) currentSlide = 0;
        if (currentSlide < 0) currentSlide = slides.length - 1;

        slides[currentSlide].classList.add('active');
        dotsContainer.children[currentSlide].classList.add('active');
    }

    // 下一张幻灯片
    function nextSlide() {
        goToSlide(currentSlide + 1);
    }

    // 上一张幻灯片
    function prevSlide() {
        goToSlide(currentSlide - 1);
    }

    // 自动播放
    function startAutoSlide() {
        stopAutoSlide();
        autoSlideInterval = setInterval(nextSlide, 5000);
    }

    // 停止自动播放
    function stopAutoSlide() {
        if (autoSlideInterval) {
            clearInterval(autoSlideInterval);
        }
    }

    // 事件监听
    if (prevButton) prevButton.addEventListener('click', prevSlide);
    if (nextButton) nextButton.addEventListener('click', nextSlide);

    // 鼠标悬停时暂停自动播放
    slider.addEventListener('mouseenter', stopAutoSlide);
    slider.addEventListener('mouseleave', startAutoSlide);

    // 开始自动播放
    startAutoSlide();

    // 视差滚动效果
    window.addEventListener('scroll', function () {
        const scrolled = window.pageYOffset;
        const heroSlides = document.querySelectorAll('.hero-background');

        heroSlides.forEach(slide => {
            const speed = 0.5;
            const yPos = -(scrolled * speed);
            slide.style.transform = `translate3d(0, ${yPos}px, 0) scale(1.1)`;
        });
    });
});

// 添加滚动动画效果
window.addEventListener('scroll', function () {
    const navbar = document.querySelector('.navbar');
    if (window.scrollY > 50) {
        navbar.style.backgroundColor = 'rgba(255, 255, 255, 0.95)';
    } else {
        navbar.style.backgroundColor = '#fff';
    }

    // 检查案例内容是否在视口中
    document.querySelectorAll('.case-content').forEach(content => {
        const rect = content.getBoundingClientRect();
        const isInViewport = rect.top <= window.innerHeight * 0.75;

        if (isInViewport) {
            content.classList.add('visible');
        }
    });
});

// 平滑滚动效果
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            target.scrollIntoView({
                behavior: 'smooth'
            });
        }
    });
});

// 视差滚动效果
window.addEventListener('scroll', function () {
    const parallaxElements = document.querySelectorAll('.parallax-case');

    parallaxElements.forEach(element => {
        const speed = 0.5;
        const rect = element.getBoundingClientRect();
        const offset = window.pageYOffset;
        const elementTop = rect.top + offset;
        const scrolled = window.pageYOffset - elementTop;

        if (rect.top < window.innerHeight && rect.bottom > 0) {
            const yPos = -(scrolled * speed);
            element.style.backgroundPosition = `center ${yPos}px`;
        }
    });
}); 